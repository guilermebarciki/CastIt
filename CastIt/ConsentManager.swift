//
//  ConsentManager.swift
//  CastIt
//
//  Centraliza ATT, consentimento regional (UMP) e o estado de coleta dos SDKs.
//  Regra: tudo começa desabilitado; só habilita após decisão explícita.
//

import UIKit
import AppTrackingTransparency
import FirebaseAnalytics
import FBSDKCoreKit
import GoogleMobileAds
import UserMessagingPlatform

final class ConsentManager {
    static let shared = ConsentManager()
    private init() {}

    private(set) var canRequestAds = false
    private var adsStarted = false
    private var gatheringConsent = false
    private var pendingAdActions: [() -> Void] = []

    // MARK: - Estado conservador (chamar antes de configurar os SDKs)

    func applyConservativeDefaults() {
        Settings.setAdvertiserTrackingEnabled(false)
        Settings.shared.isAutoLogAppEventsEnabled = false
        Settings.shared.isAdvertiserIDCollectionEnabled = false
    }

    // MARK: - Fluxo principal (chamar quando o app fica ativo)

    /// Reaplica o estado do ATT (cobre mudanças em Ajustes) e, uma vez por
    /// execução, roda UMP -> ATT -> inicialização de anúncios.
    func refresh(from presenter: UIViewController?) {
        applyTrackingState()
        guard !gatheringConsent else { return }
        gatheringConsent = true
        requestConsentInfo(from: presenter) { [weak self] in
            guard let self = self else { return }
            self.requestTrackingIfNeeded {
                self.gatheringConsent = false
                self.applyTrackingState()
                self.startAdsIfAllowed()
            }
        }
    }

    // MARK: - UMP

    private func requestConsentInfo(from presenter: UIViewController?, completion: @escaping () -> Void) {
        let params = UMPRequestParameters()
        params.tagForUnderAgeOfConsent = false
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: params) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                // Falha de rede: mantém o último status em cache; sem status
                // válido, canRequestAds permanece false.
                if error != nil {
                    self.updateCanRequestAds()
                    completion()
                    return
                }
                let info = UMPConsentInformation.sharedInstance
                guard info.formStatus == .available, info.consentStatus == .required, let presenter = presenter else {
                    self.updateCanRequestAds()
                    completion()
                    return
                }
                UMPConsentForm.load { form, _ in
                    DispatchQueue.main.async {
                        guard let form = form else {
                            self.updateCanRequestAds()
                            completion()
                            return
                        }
                        form.present(from: presenter) { _ in
                            DispatchQueue.main.async {
                                self.updateCanRequestAds()
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }

    private func updateCanRequestAds() {
        // UMP 2.0.0 não expõe canRequestAds; derivamos do status.
        let status = UMPConsentInformation.sharedInstance.consentStatus
        canRequestAds = (status == .obtained || status == .notRequired)
    }

    // MARK: - ATT

    private func requestTrackingIfNeeded(completion: @escaping () -> Void) {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            completion()
            return
        }
        ATTrackingManager.requestTrackingAuthorization { _ in
            DispatchQueue.main.async { completion() }
        }
    }

    /// Apenas `.authorized` (com consentimento regional) habilita rastreamento.
    /// `denied`, `restricted` e `notDetermined` mantêm tudo desabilitado.
    private func applyTrackingState() {
        let attAuthorized = ATTrackingManager.trackingAuthorizationStatus == .authorized
        let allowed = attAuthorized && canRequestAds
        Settings.setAdvertiserTrackingEnabled(allowed)
        Settings.shared.isAutoLogAppEventsEnabled = allowed
        Settings.shared.isAdvertiserIDCollectionEnabled = allowed
        Analytics.setAnalyticsCollectionEnabled(allowed)
        Analytics.setUserProperty(allowed ? "true" : "false",
                                  forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
    }

    // MARK: - Anúncios

    private func startAdsIfAllowed() {
        guard canRequestAds else { return }
        if !adsStarted {
            adsStarted = true
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        let actions = pendingAdActions
        pendingAdActions.removeAll()
        actions.forEach { $0() }
    }

    /// Executa a ação de carregar anúncio só quando `canRequestAds` for true;
    /// caso contrário, enfileira até o consentimento ser resolvido.
    func whenAdsAllowed(_ action: @escaping () -> Void) {
        if canRequestAds && adsStarted {
            action()
        } else {
            pendingAdActions.append(action)
        }
    }
}
