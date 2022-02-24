//
//  MenuScrollView.swift
//  CastIt
//
//  Created by Guilerme Barciki on 16/02/22.
//

import Foundation
import Foundation
import UIKit

class MenuScrollView: UIView {
    
    var menuVC: MenuSceneViewController
    init(menuVC: MenuSceneViewController) {
        self.menuVC = menuVC
//        isUserInteractionEnabled = true
        super.init(frame: .zero)
        addContinueScroll()
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
//        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
//        leaderBoardButton.addTarget(self, action: #selector(leaderBoardPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        button.backgroundColor = .green
        
        return button
    }()
    
    lazy var leaderBoardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "LeaderBoard"), for: .normal)
        
        return button
    }()
    
    func addContinueScroll() {
        
        addSubview(scroll)
        
        
        addSubview(playButton)
        addSubview(leaderBoardButton)
        setContinueScrollConstraint()
        
    }
    func removeContinueScroll() {
        scroll.removeFromSuperview()
    }
    
    func setContinueScrollConstraint() {
       
        
        NSLayoutConstraint.activate([
            scroll.centerXAnchor.constraint(equalTo: centerXAnchor),
            scroll.centerYAnchor.constraint(equalTo: centerYAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 408 * 0.8),
            scroll.widthAnchor.constraint(equalToConstant: 537 * 0.8),
            
            
            playButton.bottomAnchor.constraint(equalTo: centerYAnchor,constant:  -30),
            playButton.heightAnchor.constraint(equalToConstant: 45 * 0.9),
            playButton.widthAnchor.constraint(equalToConstant: 310 * 0.9),
            
            leaderBoardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            leaderBoardButton.topAnchor.constraint(equalTo: centerYAnchor),
            playButton.leadingAnchor.constraint(equalTo: leaderBoardButton.leadingAnchor),
            leaderBoardButton.heightAnchor.constraint(equalToConstant: 45 * 0.9),
            leaderBoardButton.widthAnchor.constraint(equalToConstant: 334 * 0.9),
        ])

        
        
    }
    @objc func playPressed(sender: UIButton!) {
        
    }
    
    @objc func leaderBoardPressed(sender: UIButton!) {
        
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: menuVC)
    }
    func addGameOverScroll() {
        
    }
    func removeGameOverScroll() {
        
    }
    func setGameOverScrollConstraint() {
    }
    
    
}

