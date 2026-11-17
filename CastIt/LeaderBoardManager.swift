//
//  LeaderBoardManager.swift
//  CastIt
//
//  Created by Guilerme Barciki on 09/02/22.
//

import GameKit

class LeaderboardManager: NSObject, GKGameCenterControllerDelegate {
    static let shared = LeaderboardManager()

    private(set) var gcEnabled = false
    private(set) var gcDefaultLeaderBoard: String?
    private weak var presentingViewController: UIViewController?
    private var pendingAuthenticationViewController: UIViewController?
    private var authenticationHandlerInstalled = false
    private var authenticationRevision = 0

    // Called by the menu after it becomes visible. Returning from a cancelled
    // login must not install another handler or automatically prompt again.
    func authenticateLocalPlayer(presentingVC: UIViewController?) {
        guard let presentingVC = presentingVC, canPresent(from: presentingVC) else { return }
        presentingViewController = presentingVC

        if authenticationHandlerInstalled {
            presentPendingAuthentication()
            return
        }
        authenticationHandlerInstalled = true

        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.authenticationRevision += 1
                let revision = self.authenticationRevision
                self.gcEnabled = false
                self.gcDefaultLeaderBoard = nil
                self.pendingAuthenticationViewController = viewController

                if viewController != nil {
                    self.presentPendingAuthentication()
                    return
                }

                if let error = error {
                    print("Game Center authentication failed: \(error)")
                    return
                }
                // A nil error also occurs when there is no authenticated player.
                guard localPlayer.isAuthenticated else { return }
                self.gcEnabled = true

                localPlayer.loadDefaultLeaderboardIdentifier { [weak self] identifier, error in
                    DispatchQueue.main.async {
                        guard let self = self,
                              self.authenticationRevision == revision,
                              localPlayer.isAuthenticated else { return }
                        if let error = error {
                            print("Unable to load default leaderboard: \(error)")
                            return
                        }
                        guard let identifier = identifier,
                              !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        self.gcDefaultLeaderBoard = identifier
                    }
                }
            }
        }
    }

    private func canPresent(from controller: UIViewController) -> Bool {
        return controller.isViewLoaded && controller.view.window != nil
            && controller.presentedViewController == nil
            && !controller.isBeingDismissed && !controller.isBeingPresented
            && controller.navigationController?.isBeingDismissed != true
    }

    private func presentPendingAuthentication() {
        guard let controller = pendingAuthenticationViewController,
              let presenter = presentingViewController,
              canPresent(from: presenter) else { return }
        pendingAuthenticationViewController = nil
        presenter.present(controller, animated: true, completion: nil)
    }

    func updateScore(with value: Int) {
        DispatchQueue.main.async {
            guard self.gcEnabled, GKLocalPlayer.local.isAuthenticated,
                  let identifier = self.gcDefaultLeaderBoard else { return }
            GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local,
                                      leaderboardIDs: [identifier]) { error in
                if let error = error {
                    print("Error updating score: \(error)")
                }
            }
        }
    }

    func navigateToLeaderboard(presentingVC: UIViewController?) {
        DispatchQueue.main.async {
            guard self.gcEnabled, GKLocalPlayer.local.isAuthenticated,
                  let identifier = self.gcDefaultLeaderBoard,
                  let presenter = presentingVC,
                  self.canPresent(from: presenter) else { return }
            let gameCenterVC = GKGameCenterViewController(
                leaderboardID: identifier, playerScope: .global, timeScope: .allTime)
            gameCenterVC.gameCenterDelegate = self
            presenter.present(gameCenterVC, animated: true, completion: nil)
        }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
