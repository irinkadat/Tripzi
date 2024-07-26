//
//  AppDelegate.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import SwiftUI
import FacebookLogin
import Stripe

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_test_51PfIh3DtMXGWpZybZ3vMKlDKiJXPvnpDC0Jsqagste5WtQiMkJzKRzKRsFg1PogbZm30S4jgjY37Liqz3JVYWBda00a7NQH2Pk"
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        print("Configured Firebase!")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handledByGoogle = GIDSignIn.sharedInstance.handle(url)
        let handledByFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return handledByGoogle || handledByFacebook
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

