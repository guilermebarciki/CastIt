//
//  MenuSceneViewController.swift
//  CastIt
//
//  Created by Guilerme Barciki on 08/02/22.
//

import UIKit

class MenuSceneViewController: UIViewController {

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle(" PLAY ", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var leaderboardsButton: UIButton = {
        let button = UIButton()
        button.setTitle(" LEADER BOARDS ", for: .normal)
        button.backgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.insertSubview(background, at: 0)
        LeaderboardManager.shared.authenticateLocalPlayer(presentingVC: self)
        addSubviews()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    func addSubviews() {
        view.addSubview(leaderboardsButton)
        view.addSubview(playButton)
        setConstraints()
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        leaderboardsButton.addTarget(self, action: #selector(leaderBoardPressed), for: .touchUpInside)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            playButton.widthAnchor.constraint(equalToConstant: 200),
            leaderboardsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 50)
        ])
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func playPressed(sender: UIButton!) {
        let gameViewController: GameViewController? = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        let myNavigationController = UINavigationController(rootViewController: gameViewController!)
        
        self.present(myNavigationController, animated: true, completion: nil)
    }
    @objc func leaderBoardPressed(sender: UIButton!) {
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: self)
    }
    


}
