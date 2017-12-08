//
//  AppDelegate.swift
//  Filmici
//
//  Created by D&M on 21.02.2017..
//  Copyright © 2017. Dunja Sasic. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //let vc = ViewController()
        let persistanceService = PersistanceService()
        let vc = TableViewController(persistanceService: persistanceService)
        let nc = UINavigationController(rootViewController:vc)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        return true
    }
}

