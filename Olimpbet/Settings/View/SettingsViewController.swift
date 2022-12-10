//
//  SettingsViewController.swift
//  Olimpbet
//
//  Created by mac on 14.11.2022.
//

import UIKit

class SettingsViewController: BaseVC {
    
    private lazy var backButton = createButton(image: UIImage(named: "close-button"),
                                               selector: #selector(backTapped))
    
    private var displayName: String = "" {
        didSet {
            let attributedString = NSAttributedString(
                string: "Display name: \n",
                attributes: [
                    .font : UIFont(name: "Copperplate Bold", size: 38) ?? .boldSystemFont(ofSize: 36),
                    .foregroundColor : UIColor.systemOrange
                ]
            )
            
            let nameAttributedString = NSAttributedString(
                string: displayName,
                attributes: [
                    .font : UIFont(name: "Copperplate Bold", size: 32) ?? .boldSystemFont(ofSize: 28),
                    .foregroundColor : UIColor.white
                ]
            )
            
            let mutableString = NSMutableAttributedString()
            mutableString.append(attributedString)
            mutableString.append(nameAttributedString)
            
            displayNameLabel.attributedText = mutableString
        }
    }
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var nameEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        button.setBackgroundImage(.edit, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let stackView: SettingsStackView = {
        let stackView = SettingsStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel, coordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "play-bg")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.alpha = 0.5
        
        view.addSubview(backgroundImageView)
        
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 12),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 56),
            backButton.widthAnchor.constraint(equalToConstant: 56)
        ])
        
        displayName = viewModel.settings.displayName
        view.addSubview(displayNameLabel)
        NSLayoutConstraint.activate([
            displayNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: 20),
            displayNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nameEditButton)
        NSLayoutConstraint.activate([
            nameEditButton.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor,
                                                    constant: 16),
            nameEditButton.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor),
            nameEditButton.widthAnchor.constraint(equalToConstant: 32),
            nameEditButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor,
                                           constant: 32),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -16),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: 0.5)
        ])
        
        setupSettingViews()
    }
    
    @objc
    private func backTapped() {
        coordinator?.eventOccured(.pop)
    }
    
    @objc
    private func editButtonTapped() {
        let alert = UIAlertController(title: "Display name: ",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.placeholder = self?.displayName
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            
            self?.viewModel.settings.displayName = text
            self?.displayName = text
        }
        
        alert.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func soundsTapped(sender: UISwitch) {
        viewModel.settings.soundsOn = sender.isOn
    }
    
    @objc
    private func invertedControlsTapped(sender: UISwitch) {
        viewModel.settings.invertedControls = sender.isOn
    }
    
    @objc
    private func privacyPolicyTapped() {
        guard let url = viewModel.privacyPolicyURL else {
            return
        }
        
        coordinator?.eventOccured(.privacyPolicy(url))
    }
    
    @objc
    private func shareAppTapped() {
        guard let link = viewModel.appStoreURL else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [link],
                                                  applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func setupSettingViews() {
        let soundsSettingView = SettingView(type: .sounds)
        soundsSettingView.addSwitch(
            isOn: viewModel.settings.soundsOn,
            target: self,
            action: #selector(soundsTapped(sender:)),
            for: .valueChanged
        )
        stackView.addArrangedSubview(soundsSettingView)
        
        let invertedControlsSettingView = SettingView(type: .invertedControls)
        invertedControlsSettingView.addSwitch(
            isOn: viewModel.settings.invertedControls,
            target: self,
            action: #selector(invertedControlsTapped(sender:)),
            for: .valueChanged
        )
        stackView.addArrangedSubview(invertedControlsSettingView)
        
        let privacyPolicySettingView = SettingView(type: .privacyPolicy)
        privacyPolicySettingView.addButton(
            image: .list,
            target: self,
            action: #selector(privacyPolicyTapped),
            for: .touchUpInside
        )
        stackView.addArrangedSubview(privacyPolicySettingView)
        
        let shareAppSettingView = SettingView(type: .shareApp)
        shareAppSettingView.addButton(
            image: .share,
            target: self,
            action: #selector(shareAppTapped),
            for: .touchUpInside
        )
        stackView.addArrangedSubview(shareAppSettingView)
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
