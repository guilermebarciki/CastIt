//
//  GameOverScrollView.swift
//  CastIt
//
//  Created by Guilerme Barciki on 14/02/22.
//

import Foundation
import Foundation
import UIKit

class GameOverScrollView: UIView {
    
    var gameVC: GameViewController
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
//        isUserInteractionEnabled = true
        super.init(frame: .zero)
        addContinueScroll()
        tryAgainButton.addTarget(self, action: #selector(tryAgainPressed), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
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
    
    lazy var gameOverText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game over"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont(name: "PressStart2P", size: 22)
        label.textColor = UIColor(named: "gameOverColor")
//        scroll.contentMode = .scaleAspectFit
        return label
    }()
    lazy var youGotText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You got \(Int(gameVC.scene.scoreControler.showScore())) points"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont(name: "PressStart2P", size: 14)
        label.textColor = UIColor(named: "gameOverColor")
//        scroll.contentMode = .scaleAspectFit
        return label
    }()
    
    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "tryAgain"), for: .normal)
        
        return button
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu"), for: .normal)
        
        return button
    }()
    
    func addContinueScroll() {
        
        addSubview(scroll)
        addSubview(gameOverText)
        addSubview(youGotText)
        
        addSubview(tryAgainButton)
        addSubview(menuButton)
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
            
            gameOverText.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 70),
            gameOverText.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            youGotText.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            youGotText.topAnchor.constraint(equalTo: gameOverText.bottomAnchor, constant: 12),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 45 * 0.8),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 286 * 0.8),
            
            menuButton.leadingAnchor.constraint(equalTo: tryAgainButton.leadingAnchor),
            menuButton.topAnchor.constraint(equalTo: tryAgainButton.bottomAnchor, constant: 10),
            menuButton.heightAnchor.constraint(equalToConstant: 45 * 0.8),
            menuButton.widthAnchor.constraint(equalToConstant: 166 * 0.8),
        ])

        
        print("scrol height \(scroll.heightAnchor)")
    }
    @objc func tryAgainPressed(sender: UIButton!) {
        print("buttonpressed")
        gameVC.scene.reset()
        gameVC.removeGameOverScrollScroll()
        gameVC.scene.clearScreen()
        gameVC.scene.status = .intro
    }
    
    @objc func menuPressed(sender: UIButton!) {
        print("buttonpressed")
        gameVC.scene.reset()
        gameVC.removeGameOverScrollScroll()
        gameVC.dismiss(animated: true, completion: nil)
    }
    func addGameOverScroll() {
        
    }
    func removeGameOverScroll() {
        
    }
    func setGameOverScrollConstraint() {
    }
    
}
