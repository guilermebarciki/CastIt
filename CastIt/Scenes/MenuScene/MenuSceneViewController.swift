//
//  MenuSceneViewController.swift
//  CastIt
//
//  Created by Guilerme Barciki on 08/02/22.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class MenuSceneViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-4847648071121480/2504562618"
        banner.load(GADRequest())
        return banner
    }()
    
    lazy var scroll: UIImageView = {
        let scroll = UIImageView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.image = UIImage(named: "scroll")
//        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "startGame"), for: .normal)
        return button
    }()
    
    lazy var leaderBoardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "LeaderBoard"), for: .normal)
        return button
    }()
    
   
    
    private lazy var background: UIImageView = {
        var image = UIImageView(frame: .zero)
        image.image = UIImage(named: "moon-background")!
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBackgroundMusic()
        
        view.insertSubview(background, at: 0)
        
        LeaderboardManager.shared.authenticateLocalPlayer(presentingVC: self)
        banner.rootViewController = self
        addSubviews()
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        leaderBoardButton.addTarget(self, action: #selector(leaderBoardPressed), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        banner.frame = CGRect(x: 0,
                              y: view.frame.height - 50,//* 0.9,
                              width: view.frame.size.width / 2,
                              height: 50//view.frame.size.height * 0.9
        )
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    func addSubviews() {
        view.addSubview(scroll)
        view.addSubview(playButton)
        view.addSubview(leaderBoardButton)
        view.addSubview(banner)
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            scroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scroll.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 408 * 0.8),
            scroll.widthAnchor.constraint(equalToConstant: 537 * 0.8),
            
            
            playButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant:  -30),
            playButton.heightAnchor.constraint(equalToConstant: 45 * 0.9),
            playButton.widthAnchor.constraint(equalToConstant: 310 * 0.9),
            
            leaderBoardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderBoardButton.topAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.leadingAnchor.constraint(equalTo: leaderBoardButton.leadingAnchor),
            leaderBoardButton.heightAnchor.constraint(equalToConstant: 45 * 0.9),
            leaderBoardButton.widthAnchor.constraint(equalToConstant: 334 * 0.9),
        ])

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
       
    }
  
    @objc func playPressed(sender: UIButton!) {
        stopMusic()
        let gameViewController: GameViewController? = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        gameViewController?.menuController = self
        let myNavigationController = UINavigationController(rootViewController: gameViewController!)
        myNavigationController.modalPresentationStyle = .fullScreen
        banner.removeFromSuperview()
        self.present(myNavigationController, animated: true, completion: nil)
    }
    
    @objc func leaderBoardPressed(sender: UIButton!) {
        banner.removeFromSuperview()
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: self)
    }
    func startBackgroundMusic() {
        
            if let bundle = Bundle.main.path(forResource: "cast it - tema", ofType: "mp3") {
                let backgroundMusic = NSURL(fileURLWithPath: bundle)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                    guard let audioPlayer = audioPlayer else { return }
                    audioPlayer.numberOfLoops = -1 // for infinite times
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print(error)
                }
            }
        }
    
    func stopMusic() {
        audioPlayer?.stop()
    }


}
