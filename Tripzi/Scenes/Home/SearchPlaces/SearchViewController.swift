//
//  SearchViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit
import Combine
import SwiftUI

protocol SearchViewControllerDelegate: AnyObject {
    func didPerformSearch(results: [PlaceListing])
}

final class SearchViewController: UIViewController {
    
    // MARK: - UI Elements

    private let searchField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Search destinations"
        return textField
    }()
    
    private let radiusContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let radiusButton: CustomSearchButton = {
        let button = CustomSearchButton()
        button.setTitle("Add radius", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let radiusField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter radius"
        textField.isHidden = true
        return textField
    }()
    
    private let nearContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nearButton: CustomSearchButton = {
        let button = CustomSearchButton()
        button.setTitle("Add Near or Lat&Long", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nearField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "near"
        textField.isHidden = true
        return textField
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .uniCo
        return button
    }()
    
    // MARK: - Properties

    weak var delegate: SearchViewControllerDelegate?
    private var viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = .uniModal
        setupUI()
        setupActions()
        setupBindings()
    }
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.uniCo, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 26
        button.backgroundColor = .uniButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        radiusContainer.addArrangedSubview(radiusButton)
        radiusContainer.addArrangedSubview(radiusField)
        
        nearContainer.addArrangedSubview(nearButton)
        nearContainer.addArrangedSubview(nearField)
        
        let stackView = UIStackView(arrangedSubviews: [searchField, nearContainer, radiusContainer])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(searchButton)
        searchButton.addAction(UIAction(handler: { _ in self.performSearch() }), for: .touchUpInside)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 52),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        let closeAction = UIAction { [weak self] _ in
            self?.didTapCloseButton()
        }
        closeButton.addAction(closeAction, for: .touchUpInside)
        
        radiusButton.addTarget(self, action: #selector(didTapRadiusButton), for: .touchUpInside)
        nearButton.addTarget(self, action: #selector(didTapLatLongButton), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onListingsUpdate = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.delegate?.didPerformSearch(results: self.viewModel.listings)
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRadiusButton() {
        toggleTextField(radiusField)
    }
    
    @objc private func didTapLatLongButton() {
        toggleTextField(nearField)
    }
    
    private func toggleTextField(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.isHidden.toggle()
            self.view.layoutIfNeeded()
        }
    }
    
    private func performSearch() {
        let query = searchField.text ?? ""
        let radius = Int(radiusField.text ?? "")
        let ll = nearField.text
        
        viewModel.searchPlaces(query: query, radius: radius, near: ll)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func didReceiveValidationMessage(_ message: String) {
        showAlert(message: message)
    }
}

extension Notification.Name {
    static let searchPerformed = Notification.Name("searchPerformed")
}

#Preview {
    SearchViewController()
}

