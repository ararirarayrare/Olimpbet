//
//  MenuViewController.swift
//  Olimpbet
//
//  Created by mac on 09.11.2022.
//

import UIKit

class MenuViewController: BaseVC {
    
    private var playButtonLeadingConstraint: NSLayoutConstraint!
    private lazy var playButton = createButton(title: "Play",
                                               selector: #selector(playTapped))
    
    private var leaderboardButtonLeadingConstraint: NSLayoutConstraint!
    private lazy var leaderboardButton = createButton(title: "Leaderboad",
                                                     selector: #selector(gameCenterTapped))
    
    private var settingsButtonLeadingConstraint: NSLayoutConstraint!
    private lazy var settingsButton = createButton(title: "Settings",
                                                   selector: #selector(settingsTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "menu-bg")
        backgroundImageView.contentMode = .scaleToFill
        view.addSubview(backgroundImageView)
        
        view.addSubview(leaderboardButton)
        leaderboardButtonLeadingConstraint = leaderboardButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        NSLayoutConstraint.activate([
            leaderboardButtonLeadingConstraint,
            leaderboardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leaderboardButton.widthAnchor.constraint(equalToConstant: 200),
            leaderboardButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        view.addSubview(playButton)
        playButtonLeadingConstraint = playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        NSLayoutConstraint.activate([
            playButtonLeadingConstraint,
            playButton.bottomAnchor.constraint(equalTo: leaderboardButton.topAnchor,
                                               constant: -20),
            playButton.widthAnchor.constraint(equalTo: leaderboardButton.widthAnchor),
            playButton.heightAnchor.constraint(equalTo: leaderboardButton.heightAnchor)
        ])
        
        view.addSubview(settingsButton)
        settingsButtonLeadingConstraint = settingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        NSLayoutConstraint.activate([
            settingsButtonLeadingConstraint,
            settingsButton.topAnchor.constraint(equalTo: leaderboardButton.bottomAnchor,
                                                constant: 20),
            settingsButton.widthAnchor.constraint(equalTo: leaderboardButton.widthAnchor),
            settingsButton.heightAnchor.constraint(equalTo: leaderboardButton.heightAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateButtons(shouldAppear: true)
    }
    
    @objc
    private func playTapped() {
        animateButtons(shouldAppear: false) { [weak self] in
            self?.coordinator?.eventOccured(.play)
        }
    }
    
    @objc
    private func gameCenterTapped() {
        
    }
    
    @objc
    private func settingsTapped() {
        animateButtons(shouldAppear: false) { [weak self] in
            self?.coordinator?.eventOccured(.settings)
        }
    }
    
    
    private func animateButtons(shouldAppear: Bool, completion: (() -> Void)? = nil) {
        var delay: Double = 0
        
        let constraints = [playButtonLeadingConstraint, leaderboardButtonLeadingConstraint, settingsButtonLeadingConstraint]
        
        let dispatchGroup = DispatchGroup()
        
        (shouldAppear ? constraints : constraints.reversed())
            .forEach { constraint in
                constraint?.constant = shouldAppear ? -300 : 32
                view.layoutIfNeeded()
                
                dispatchGroup.enter()
                UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseInOut) { [weak self] in
                    constraint?.constant = shouldAppear ? 32 : -300
                    self?.view.layoutIfNeeded()
                } completion: { _ in
                    dispatchGroup.leave()
                }
                
                delay += 0.15
            }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    private func createButton(title: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate Bold", size: 28)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.systemOrange.cgColor
        button.layer.shadowRadius = 12
        
        return button
    }
    
}
