//
//  SearchViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search destinations"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let whenButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Add dates"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        button.configuration = configuration
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let whoButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Add guests"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        button.configuration = configuration
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
//    private let closeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("X", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
//        button.setTitleColor(.black, for: .normal)
//        return button
//    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [searchField, whenButton, whoButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        let closeAction = UIAction { [weak self] _ in
            self?.didTapCloseButton()
        }
        closeButton.addAction(closeAction, for: .touchUpInside)
    }
    
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
