//
//  ContinueScrollView.swift
//  CastIt
//
//  Created by Guilerme Barciki on 13/02/22.
//

import Foundation
import UIKit

class ContinueScrollView: UIView {
    
    var gameVC: GameViewController
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
//        isUserInteractionEnabled = true
        super.init(frame: .zero)
        gameVC.scene.pauseGame()
        addContinueScroll()
        adButton.addTarget(self, action: #selector(adPressed), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scroll: UIImageView = {
        let scroll = UIImageView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.image = UIImage(named: "scroll")
        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    lazy var continueText: UIImageView = {
        let scroll = UIImageView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.image = UIImage(named: "wantContinue")
        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
    lazy var adButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "adButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "X"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    func addContinueScroll() {
        addSubview(scroll)
        addSubview(continueText)
        addSubview(adButton)
        addSubview(closeButton)
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
            
            closeButton.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 50),
            closeButton.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -40),
//            closeButton.heightAnchor.constraint(equalToConstant: 100),
//            closeButton.widthAnchor.constraint(equalToConstant: 100),

            
            
            continueText.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            continueText.heightAnchor.constraint(equalToConstant: 48 * 0.8),
            continueText.widthAnchor.constraint(equalToConstant: 336 * 0.8),
            continueText.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            
            adButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            adButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            adButton.heightAnchor.constraint(equalToConstant: 24 * 0.8),
            adButton.widthAnchor.constraint(equalToConstant: 240 * 0.8)
        ])

        
        print("scrol height \(scroll.heightAnchor)")
    }
    @objc func adPressed(sender: UIButton!) {
        print("buttonpressed")
        gameVC.scene.pauseGame()
        gameVC.showRewardedAD()
        gameVC.scene.audioManager.stopMusic()
    }
    @objc func closePressed(sender: UIButton!) {
        print("closed pressed")
        gameVC.scene.scoreControler.updateScore()
        
        gameVC.scene.status = .gameOver
        gameVC.removeContinueScroll()
        
    }
    
}

