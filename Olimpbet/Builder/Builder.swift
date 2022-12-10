//
//  Builder.swift
//  Olimpbet
//
//  Created by mac on 07.11.2022.
//

import UIKit

protocol Builder {
    func createGame(coordinator: Coordinator) -> MenuViewController
    func createPlay(coordinator: Coordinator) -> GameViewController
    func createGameOver(coordinator: Coordinator, playersScore: [String : Int]) -> GameOverViewController
    func createSettings(coordinator: Coordinator) -> SettingsViewController
    func createPrivacyPolicy(url: URL, coordinator: Coordinator) -> WebViewController
    func createInfo() -> InfoPageViewController
}

class MainBuilder: Builder {
        
    func createGame(coordinator: Coordinator) -> MenuViewController {
        let vc = MenuViewController(coordinator: coordinator)
        return vc
    }
    
    func createPlay(coordinator: Coordinator) -> GameViewController {
        let settings = Settings()
        let multiplayerManager = MultiplayerManager(displayName: settings.displayName,
                                                    coordinator: coordinator)
        let viewModel = GameViewModel(settings: settings, multiplayerManager: multiplayerManager)
        
        let vc = GameViewController(viewModel: viewModel, coordinator: coordinator)
        
        return vc
    }
    
    func createGameOver(coordinator: Coordinator, playersScore: [String : Int]) -> GameOverViewController {
        let vc = GameOverViewController(playersScore: playersScore, coordinator: coordinator)
        
        return vc
    }
    
    func createSettings(coordinator: Coordinator) -> SettingsViewController {
        let settings = Settings()
        let viewModel = SettingsViewModel(settings: settings)
        let vc = SettingsViewController(viewModel: viewModel, coordinator: coordinator)
        
        return vc
    }
    
    func createPrivacyPolicy(url: URL, coordinator: Coordinator) -> WebViewController {
        let vc = WebViewController(url: url, coordinator: coordinator)
        return vc
    }
    
    func createInfo() -> InfoPageViewController {
        let vc = InfoPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return vc
    }
}


