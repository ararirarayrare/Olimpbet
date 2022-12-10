//
//  AppDelegate.swift
//  Olimpbet
//
//  Created by mac on 04.11.2022.
//

import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        
        let loader = LoaderViewController { [weak self] in
            let navController = BaseNC()
            let builder = MainBuilder()
            
            let coordinator = MainCoordinator(navigationController: navController,
                                              builder: builder)
            coordinator.start()
            
            self?.window?.rootViewController = navController
        }
        
        window?.rootViewController = loader
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension UInt32 {
    static let playerBitMask: UInt32 = 0x1 << 0
    static let ballBitMask: UInt32 = 0x1 << 1
    static let pillarBitMask: UInt32 = 0x1 << 2
}

extension UIImage {
    static var edit: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        return UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)
    }
    
    static var info: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        return UIImage(systemName: "info.circle", withConfiguration: imageConfig)
    }
    
    static var share: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        return UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
    }
    
    static var list: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        return UIImage(systemName: "list.bullet.rectangle", withConfiguration: imageConfig)
    }
}
