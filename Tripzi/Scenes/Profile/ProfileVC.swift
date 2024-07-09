//
//  ProfileVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    private var authManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogoutButton()
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .systemBlue
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleLogout() {
        authManager.signOut()
        presentLoginScreen()
        
    }
}

private func presentLoginScreen() {
    if let sceneDelegate = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive })?.delegate as? SceneDelegate {
        sceneDelegate.resetToLoginScreen()
    }
}

private func showErrorMessage(_ message: String) {
    let alert = UIAlertController(title: "Logout Failed", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
}


