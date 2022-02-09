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
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    func addButtons() {
        view.addSubview(leaderboardsButton)
        view.addSubview(playButton)
        butonConstraints()
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
    }
    
    func butonConstraints() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            playButton.widthAnchor.constraint(equalToConstant: 200),
            leaderboardsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 50)
        ])
    }
    
    @objc func playPressed(sender: UIButton!) {
        let gameViewController: GameViewController? = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        let myNavigationController = UINavigationController(rootViewController: gameViewController!)
        
        self.present(myNavigationController, animated: true, completion: nil)
    }
    


}
