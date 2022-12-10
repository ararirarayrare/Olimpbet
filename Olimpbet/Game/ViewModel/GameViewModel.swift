//
//  GameViewModel.swift
//  Olimpbet
//
//  Created by mac on 09.11.2022.
//

import Foundation

class GameViewModel {
    
    let multiplayerManager: MultiplayerManager?
    
    let settings: Settings
    
    init(settings: Settings, multiplayerManager: MultiplayerManager? = nil) {
        self.settings = settings
        self.multiplayerManager = multiplayerManager
        multiplayerManager?.startHosting()
    }
    
}
