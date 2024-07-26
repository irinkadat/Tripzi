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
        navigationController?.navigationBar.tintColor = .uniCo
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

extension UIButton {
    func setIconSize(width: CGFloat, height: CGFloat) {
        guard let imageView = self.imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

