//
//  ViewController.swift
//  Olimpbet
//
//  Created by mac on 04.11.2022.
//

import UIKit

class GameViewController: BaseVC {
    
    private lazy var gameView: GameView = {
        let gameView = GameView(frame: view.bounds, settings: viewModel.settings)
        gameView.backgroundColor = .darkGray
        return gameView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "play-bg")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.alpha = 0.6
        return backgroundImageView
    }()
    
    private lazy var backButton = createButton(image: UIImage(named: "close-button"),
                                               selector: #selector(backTapped))
    
    private lazy var trainingButton = createButton(title: "Training",
                                                   selector: #selector(trainingTapped))
    
    private lazy var multiplayerButton = createButton(title: "Multiplayer",
                                                      selector: #selector(multiplayerTapped))
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setBackgroundImage(.info, for: .normal)
        button.tintColor = .systemOrange
        
        button.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var loadingLabel: UILabel?
    private var activityIndicator: UIActivityIndicatorView?
    
    let viewModel: GameViewModel
    
    init(viewModel: GameViewModel, coordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(backgroundImageView)
        
        setupButtons()
        
        if let multiplayerManager = viewModel.multiplayerManager {
            multiplayerManager.$state
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    switch state {
                    case .notConnected:
                        break
                        
                    case .connecting:
                        self?.multiplayerButton.removeFromSuperview()
                        self?.trainingButton.removeFromSuperview()
                        self?.infoButton.removeFromSuperview()
                        self?.backButton.isHidden = true
                        
                        guard self?.gameView.superview == nil else {
                            return
                        }
                        
                        self?.animateLoading()
                    case .connected:
                    
                        self?.loadingLabel?.removeFromSuperview()
                        self?.activityIndicator?.removeFromSuperview()
                                                
                        guard let gameView = self?.gameView,
                              let backButton = self?.backButton else {
                            return
                        }
                        
                        gameView.multiplayerManager = multiplayerManager
                        self?.view.insertSubview(gameView, belowSubview: backButton)
                        gameView.loadScene()
                        backButton.setBackgroundImage(UIImage(named: "home-button"), for: .normal)
                        backButton.layer.shadowRadius = 0
                        backButton.isHidden = false
                        
                        multiplayerManager.stopAdvertising()
                        
                    @unknown default:
                        break
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    @objc
    private func infoTapped() {
        coordinator?.eventOccured(.info)
    }
    
    @objc
    private func backTapped() {
        coordinator?.eventOccured(.pop)
    }
    
    @objc
    private func trainingTapped() {
        backgroundImageView.removeFromSuperview()
        trainingButton.removeFromSuperview()
        multiplayerButton.removeFromSuperview()
        infoButton.removeFromSuperview()
        
        view.insertSubview(gameView, belowSubview: backButton)
        gameView.loadScene()
        backButton.setBackgroundImage(UIImage(named: "home-button"), for: .normal)
        backButton.layer.shadowRadius = 0
    }
    
    @objc
    private func multiplayerTapped() {
        viewModel.multiplayerManager?.joinSession()
    }
    
    private func setupButtons() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 12),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 56),
            backButton.widthAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(trainingButton)
        NSLayoutConstraint.activate([
            trainingButton.trailingAnchor.constraint(equalTo: view.centerXAnchor,
                                                     constant: -16),
            trainingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trainingButton.widthAnchor.constraint(equalToConstant: 200),
            trainingButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        view.addSubview(multiplayerButton)
        NSLayoutConstraint.activate([
            multiplayerButton.leadingAnchor.constraint(equalTo: view.centerXAnchor,
                                                       constant: 16),
            multiplayerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            multiplayerButton.widthAnchor.constraint(equalToConstant: 200),
            multiplayerButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        view.addSubview(infoButton)
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16),
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 20),
            infoButton.widthAnchor.constraint(equalToConstant: 40),
            infoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func animateLoading() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Copperplate Bold", size: 40)
        label.textColor = .orange
        label.textAlignment = .left
        label.text = "Connecting..."
        
        self.loadingLabel = label
        self.backgroundImageView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        var loadingText = "Connecting..."
        var text = ""
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            text += String(describing: loadingText.removeFirst())
            label.text = text
            
            if loadingText.isEmpty {
                loadingText = "Connecting..."
                text = ""
            }
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        self.activityIndicator = activityIndicator
        self.backgroundImageView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: label.trailingAnchor,
                                                       constant: 16),
            activityIndicator.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func createButton(title: String? = nil, image: UIImage? = nil, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = (image == nil) ? .orange : .clear
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate Bold", size: 28)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setBackgroundImage(image, for: .normal)
        
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.systemOrange.cgColor
        button.layer.shadowRadius = 12
        
        return button
    }
}

