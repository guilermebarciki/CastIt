//
//  GameViewController.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADFullScreenContentDelegate {

    private var interstitial: GADInterstitialAd?
    private var rewarded: GADRewardedAd?
    
  
    lazy var continueScroll: ContinueScrollView = {
        let scroll = ContinueScrollView(gameVC: self)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    lazy var pauseScroll: PauseScrollView = {
        let scroll = PauseScrollView(gameVC: self)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    lazy var gameOverScroll: GameOverScrollView = {
        let scroll = GameOverScrollView(gameVC: self)
        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pauseButton"), for: .normal)
        return button
    }()
    
    var scene:GameScene!
    var showingRewardAd: Bool = false
    var showingInterstitialAd: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pauseButton.heightAnchor.constraint(equalToConstant: 50),
            pauseButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScsuper.init(frame: .zero)ene.sks'
            scene = SKScene(fileNamed: "GameScene") as? GameScene
            scene.gameVC = self
            // Set the scale mode to scale to fit the window
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                scene.scaleMode = .aspectFill
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                scene.scaleMode = .resizeFill
            }
            
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }

        
        requestInterstitial()
        requestRewarded()
    }
    
    func addContinueScroll() {
        let viewHeight = view.bounds.height
        view.addSubview(continueScroll)
        NSLayoutConstraint.activate([
            continueScroll.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            continueScroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueScroll.heightAnchor.constraint(equalToConstant: 408 * 0.8),
            continueScroll.widthAnchor.constraint(equalToConstant: 537 * 0.8),
//            continueScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            continueScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//            continueScroll.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.2),
//            continueScroll.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.2 )
        ])
    }
    
    func removeContinueScroll() {
        continueScroll.removeFromSuperview()
    }
    
    func addGameOverScroll() {
        let viewHeight = view.bounds.height
        view.addSubview(gameOverScroll)
        
        NSLayoutConstraint.activate([
            gameOverScroll.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameOverScroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverScroll.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.5),
            gameOverScroll.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5)
        ])
    }
    
    func removeGameOverScrollScroll() {
        gameOverScroll.removeFromSuperview()
    }
    
    func addPauseScroll() {
        view.addSubview(pauseScroll)
        
        NSLayoutConstraint.activate([
            pauseScroll.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pauseScroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseScroll.heightAnchor.constraint(equalToConstant: view.bounds.height),
            pauseScroll.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
    }
    
    func removePauseScroll() {
        pauseScroll.removeFromSuperview()
    }
    
    func showPauseButton() {
        pauseButton.isHidden = false
    }
    
    func removePauseButton() {
        pauseButton.isHidden = true
    }
    
    func requestRewarded() {
        let request = GADRequest()
        GADRewardedAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
            request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                    return
                }
                rewarded = ad
                rewarded?.fullScreenContentDelegate = self
        })
    }
    
    func showRewardedAD(){
        showingRewardAd = true
        print("teste - reward showed")
        if let rewarded = rewarded {
            rewarded.present(fromRootViewController: self, userDidEarnRewardHandler: {
                //let reward = rewarded.adReward
                print("teste - rewarded1")
                self.scene.getReward()
            })
        }
        else {
            print("Ad wasn't ready")
        }
    }
    
    func requestInterstitial() {
        // Load Interstitial AD
        showingInterstitialAd = true
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                              return
                            }
                            interstitial = ad
                            interstitial?.fullScreenContentDelegate = self
                          }
        )
    }
    
    func showInterstitialAD() {
        if let interstitial = interstitial {
            print("teste - show interstitialAD")
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad presented full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
        //PAUSAR MUSICA E JOGO
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        if showingRewardAd {
            requestRewarded()
            showingRewardAd = false
        }
        if showingInterstitialAd {
            requestInterstitial()
            showingInterstitialAd = false
        }
        
        if scene.status == .playing {
            scene.unpauseGame()
        }
        //VOLTAR MÚSICA E JOGO
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all// or .top
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
public enum UIUserInterfaceIdiom : Int {

    case unspecified

    case phone // iPhone and iPod touch style UI

    case pad // iPad style UI

    @available(iOS 9.0, *)
    case tv // Apple TV style UI

    @available(iOS 9.0, *)
    case carPlay // CarPlay style UI
}
