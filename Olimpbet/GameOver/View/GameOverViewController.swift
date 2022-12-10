//
//  GameOverViewController.swift
//  Olimpbet
//
//  Created by mac on 10.11.2022.
//

import UIKit

class GameOverViewController: BaseVC {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: view.bounds.height - 36,
                                      height: view.bounds.height - 36)
        imageView.center = view.center
        imageView.image = UIImage(named: "game-over-bg")
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var medalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 100, height: 130)
        imageView.center.x = backgroundImageView.bounds.midX
        imageView.contentMode = .scaleToFill
                
        if let myScore = scores["You"] {
            var playersWithHigherScore = 0
            scores.values.forEach { score in
                if score > myScore {
                    playersWithHigherScore += 1
                }
            }
            
            let myPlace = playersWithHigherScore + 1

            imageView.image = UIImage(named: "\(myPlace)-medal")

        }
                
        return imageView
    }()
    
    private lazy var stackView: ScoresStackView = {
        let stackView = ScoresStackView(playersScore: scores)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate Bold", size: 28)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.systemOrange.cgColor
        button.layer.shadowRadius = 12
        
        return button
    }()
    
    private let scores: [String : Int]
    
    init(playersScore: [String : Int], coordinator: Coordinator?) {
        self.scores = playersScore
        
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(medalImageView)
        
        backgroundImageView.addSubview(medalImageView)
        
        backgroundImageView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: medalImageView.bottomAnchor,
                                           constant: 8),
            stackView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor,
                                             multiplier: 0.9),
            stackView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor)
        ])
        
        backgroundImageView.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,
                                            constant: 16),
//            menuButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor,
//                                               constant: -20),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 200),
            menuButton.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor)
        ])
    }
    
    @objc
    private func menuTapped() {
        coordinator?.eventOccured(.popToRoot)
    }
}
