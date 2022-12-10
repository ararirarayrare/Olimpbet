//
//  SettingsStackView.swift
//  Olimpbet
//
//  Created by mac on 14.11.2022.
//

import UIKit

class SettingsStackView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        layer.cornerRadius = 20
        stackView.layer.cornerRadius = layer.cornerRadius
        stackView.layer.masksToBounds = true
        
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.systemOrange.cgColor
        layer.shadowRadius = 8
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum SettingViewType {
    case invertedControls, sounds, privacyPolicy, shareApp
    
    var title: String {
        switch self {
        case .invertedControls:
            return "Inverted controls"
        case .sounds:
            return "Sounds"
        case .privacyPolicy:
            return "Privacy Policy"
        case .shareApp:
            return "Share App"
        }
    }
}

class SettingView: UIView {
     
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Copperplate Bold", size: 24)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    let type: SettingViewType
    
    init(type: SettingViewType) {
        self.type = type
        super.init(frame: .zero)
        
        backgroundColor = .black.withAlphaComponent(0.8)
        
        titleLabel.text = type.title
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -80),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addButton(image: UIImage?, target: Any?, action: Selector, for event: UIControl.Event) {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setBackgroundImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(target, action: action, for: event)
        
        addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 36),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addSwitch(isOn: Bool, target: Any?, action: Selector, for event: UIControl.Event) {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.isOn = isOn
        uiSwitch.addTarget(target, action: action, for: event)
        
        addSubview(uiSwitch)
        NSLayoutConstraint.activate([
            uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
