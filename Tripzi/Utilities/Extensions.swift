//
//  Extensions.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 23.07.24.
//

import UIKit

extension UIViewController {
    func setupCustomBackButtonStyle() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
}

extension Notification.Name {
    static let AuthStateDidChange = Notification.Name("AuthStateDidChange")
}

extension UIViewController {
    func configureNavigationBarTitle(title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
