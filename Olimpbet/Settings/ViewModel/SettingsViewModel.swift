//
//  SettingsViewModel.swift
//  Olimpbet
//
//  Created by mac on 14.11.2022.
//

import Foundation

class SettingsViewModel {
    
    var appStoreURL: URL? {
        let stringURL = "https://apps.apple.com/ua/app/olimp-app/id6444449237"
        return URL(string: stringURL)
    }
    
    var privacyPolicyURL: URL? {
        let stringURL = "https://docs.google.com/document/d/1q9urYIePD6O1PVKdDFti8xy0Ic2quk3lFl7sy4AHEWc/edit?usp=sharing"
        return URL(string: stringURL)
    }
    
    let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
}
