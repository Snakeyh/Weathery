//
//  AppDelegate.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootContainer().makeInitalScreen()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }
    
}
