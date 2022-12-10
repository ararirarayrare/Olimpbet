//
//  Settings.swift
//  Olimpbet
//
//  Created by mac on 14.11.2022.
//

import UIKit

class Settings {
    
    var displayName: String {
        get {
            return UserDefaults.standard.string(forKey: "displayName") ?? UIDevice.current.name
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "displayName")
        }
    }
    
    var soundsOn: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: "soundsOff")
        }
        
        set {
            UserDefaults.standard.set(!newValue, forKey: "soundsOff")
        }
    }
    
    var invertedControls: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "invertedControls")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "invertedControls")
        }
    }
    
}
