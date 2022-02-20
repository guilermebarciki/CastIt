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
//        adButton.addTarget(self, action: #selector(adPressed), for: .touchUpInside)
//        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
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
        stackView.backgroundColor = .green
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
            stackView.centerYAnchor.constraint(equalTo: scroll.centerYAnchor)
//            stackView.topAnchor.constraint(equalTo: scroll.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor)
            
            
//            closeButton.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 50),
//            closeButton.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -40),
//
//
//
//            continueText.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
//            continueText.heightAnchor.constraint(equalToConstant: 48 * 0.8),
//            continueText.widthAnchor.constraint(equalToConstant: 336 * 0.8),
//            continueText.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
//
//            adButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            adButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
//            adButton.heightAnchor.constraint(equalToConstant: 24 * 0.8),
//            adButton.widthAnchor.constraint(equalToConstant: 240 * 0.8)
        ])

        
        print("scrol height \(scroll.heightAnchor)")
    }
    
    @objc func continuePressed(sender: UIButton!) {
        print("continue pressed")
        gameVC.pauseButton.isHidden = false
        gameVC.scene.unpauseGame()
        
        gameVC.removePauseScroll()
    }
    
    @objc func retryPressed(sender: UIButton!) {
        gameVC.pauseButton.isHidden = false
    }
    
    @objc func menuPressed(sender: UIButton!) {
        
    }
    
   
    
}

