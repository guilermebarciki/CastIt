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
    
    lazy var continueText: UIImageView = {
        let scroll = UIImageView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.image = UIImage(named: "wantContinue")
//        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "tryAgain"), for: .normal)
        button.backgroundColor = .purple
        return button
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    func addContinueScroll() {
        addSubview(scroll)
        addSubview(continueText)
        
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
            
            continueText.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 100),
            continueText.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            tryAgainButton.heightAnchor.constraint(equalToConstant: 100),
//            tryAgainButton.widthAnchor.constraint(equalToConstant: 500),
            
            menuButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            menuButton.topAnchor.constraint(equalTo: tryAgainButton.bottomAnchor)
        ])

        
        print("scrol height \(scroll.heightAnchor)")
    }
    @objc func tryAgainPressed(sender: UIButton!) {
        print("buttonpressed")
        gameVC.scene.reset()
        gameVC.scene.clearScreen()
        gameVC.removeGameOverScrollScroll()
        gameVC.scene.status = .intro
    }
    
    @objc func menuPressed(sender: UIButton!) {
        print("buttonpressed")
        gameVC.removeGameOverScrollScroll()
        gameVC.scene.status = .intro
    }
    func addGameOverScroll() {
        
    }
    func removeGameOverScroll() {
        
    }
    func setGameOverScrollConstraint() {
    }
    
}
