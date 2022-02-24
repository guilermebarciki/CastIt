//
//  PauseScroll.swift
//  CastIt
//
//  Created by Guilerme Barciki on 17/02/22.
//



import Foundation
import UIKit

class PauseScrollView: UIView {
    
    var gameVC: GameViewController
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
//        isUserInteractionEnabled = true
        super.init(frame: .zero)
//        gameVC.scene.pauseGame()
        addContinueScroll()
        continueButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryPressed), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    lazy var background: UIView = {
//        background = UIView()
//        background.frame = CGRect(x: -gameVC.scene.frame.midX,
//                                  y: -gameVC.scene.frame.midY,
//                                  width: gameVC.scene.frame.width,
//                                  height: gameVC.scene.frame.height)
//        background.alpha = 0
//        background.translatesAutoresizingMaskIntoConstraints = false
//        background.backgroundColor = .purple
//
//        return background
//    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .green
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 16
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var scroll: UIImageView = {
        let scroll = UIImageView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.image = UIImage(named: "scroll")
        scroll.contentMode = .scaleAspectFit
        return scroll
    }()
    
  
    
    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Retry"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Continue"), for: .normal)
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
//        addSubview(background)
        addSubview(scroll)
        addSubview(stackView)
//        stackView.addArrangedSubview(closeButton)r
        stackView.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(retryButton)
        stackView.addArrangedSubview(menuButton)
        
//        addSubview(continueText)
//        addSubview(adButton)
//        addSubview(closeButton)
        setContinueScrollConstraint()
        
    }
    func removeContinueScroll() {
        scroll.removeFromSuperview()
    }
    
    func setContinueScrollConstraint() {
       
        
        NSLayoutConstraint.activate([
//            background.centerXAnchor.constraint(equalTo: centerXAnchor),
//            background.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            scroll.centerXAnchor.constraint(equalTo: centerXAnchor),
            scroll.centerYAnchor.constraint(equalTo: centerYAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 408 * 0.8),
            scroll.widthAnchor.constraint(equalToConstant: 537 * 0.8),
            
            stackView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: scroll.centerYAnchor, constant:  -10)
        ])

        
        
    }
    
    @objc func continuePressed(sender: UIButton!) {
        
        gameVC.pauseButton.isHidden = false
        gameVC.scene.unpauseGame()
        
        gameVC.removePauseScroll()
    }
    
    @objc func retryPressed(sender: UIButton!) {
        gameVC.pauseButton.isHidden = false
        gameVC.scene.reset()
        gameVC.removePauseScroll()
        gameVC.scene.status = .intro

    }
    
    @objc func menuPressed(sender: UIButton!) {
        
        if let controller = gameVC.menuController {
            
            gameVC.scene.audioManager.stopMusic()
            controller.startBackgroundMusic()
        }
        gameVC.removePauseScroll()
        gameVC.dismiss(animated: true, completion: nil)
    }
    
   
    
}

