//
//  WebViewController.swift
//  Olimpbet
//
//  Created by mac on 14.11.2022.
//

import UIKit
import WebKit

class WebViewController: BaseVC {
    
    private lazy var backButton = createButton(image: UIImage(named: "left-button"),
                                               selector: #selector(backTapped))
    
    let url: URL
    
    init(url: URL, coordinator: Coordinator?) {
        self.url = url
        super.init(coordinator: coordinator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.load(URLRequest(url: url))
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
                
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 12),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 56),
            backButton.widthAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc
    private func backTapped() {
        coordinator?.eventOccured(.pop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
