//
//  SceneDelegate.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import UIKit
import FirebaseAuth

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = RootViewController()
        
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkAuthenticationAndPresentLoginIfNeeded(rootViewController: rootViewController)
        }
    }
    
    private func checkAuthenticationAndPresentLoginIfNeeded(rootViewController: UIViewController) {
        if Auth.auth().currentUser == nil {
            let authVC = AuthenticationVC()
            authVC.modalPresentationStyle = .popover
            rootViewController.present(authVC, animated: true, completion: nil)
        }
    }
    
    func resetToLoginScreen() {
        guard let window = self.window else { return }
        
        let rootViewController = RootViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let authVC = AuthenticationVC()
            authVC.modalPresentationStyle = .popover
            rootViewController.present(authVC, animated: true, completion: nil)
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
