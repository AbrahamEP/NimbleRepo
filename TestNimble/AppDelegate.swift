//
//  AppDelegate.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 04/11/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as? LoginViewController {
//            // Check your login state here
//            let isLoggedIn = /* Your login check logic */
//            
//            if isLoggedIn {
//                if let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewControllerIdentifier") as? MainViewController {
//                    window?.rootViewController = mainViewController
//                }
//            } else {
//                window?.rootViewController = loginViewController
//            }
//        }
//        
//        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

