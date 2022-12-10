//
//  Coordinator.swift
//  Olimpbet
//
//  Created by mac on 07.11.2022.
//

import UIKit

enum Event {
    case pop, popToRoot
    case play, settings, leaderboard, info
    case mcBrowser(UIViewController)
    case gameOver([String : Int])
    case privacyPolicy(URL)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}

protocol Coordinator {
    var navigationController: BaseNC { get }
    var builder: Builder { get }
    init(navigationController: BaseNC, builder: Builder)
    
    func eventOccured(_ event: Event)
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: BaseNC
    var builder: Builder
    
    private(set) var viewControllers: [BaseVC]?
    
    required init(navigationController: BaseNC, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .play:
            let vc = builder.createPlay(coordinator: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            
        case .mcBrowser(let mcBrowser):
            viewControllers?.last?.present(mcBrowser, animated: true)
            
        case .gameOver(let playersScore):
            let vc = builder.createGameOver(coordinator: self, playersScore: playersScore)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            
        case .settings:
            let vc = builder.createSettings(coordinator: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            
        case .leaderboard:
            break
            
        case .info:
            let vc = builder.createInfo()
            vc.modalPresentationStyle = .formSheet
            viewControllers?.last?.present(vc, animated: true)
            
        case .privacyPolicy(let url):
            let vc = builder.createPrivacyPolicy(url: url, coordinator: self)
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true)

        case .pop:
            guard let last = viewControllers?.last else {
                fatalError("ti sho ebanulsa?")
            }
            
            if last.presentationController == nil {
                navigationController.popViewController(animated: true)
            } else {
                last.dismiss(animated: true)
                viewControllers?.removeLast()
            }
            
        case .popToRoot:
            guard let rootVC = viewControllers?.first else {
                return
            }
            navigationController.dismiss(animated: true)
            navigationController.popToRootViewController(animated: true)
            viewControllers = [rootVC]
        }
    }
    
    func start() {
        let mainVC = builder.createGame(coordinator: self)
        navigationController.viewControllers = [mainVC]
        viewControllers = [mainVC]
    }
    
    private func present(_ vc: BaseVC, animated: Bool) {
        viewControllers?.last?.present(vc, animated: true)
        viewControllers?.append(vc)
    }
}
