//
//  AuthenticationVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import SwiftUI
import Combine

class AuthenticationVC: UIViewController {
    private var viewModel = AuthenticationViewModel()
    private var hostingController: UIHostingController<AnyView>? = nil
    private var cancellables: Set<AnyCancellable> = []
    @Published var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        let loginView = AnyView(LoginView().environmentObject(viewModel))
        switchToSwiftUIView(loginView)
    }
    
    private func switchToSwiftUIView(_ swiftUIView: AnyView) {
        if let hostingController = hostingController {
            hostingController.rootView = swiftUIView
        } else {
            let hostingController = UIHostingController(rootView: swiftUIView)
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            self.hostingController = hostingController
        }
    }
}
