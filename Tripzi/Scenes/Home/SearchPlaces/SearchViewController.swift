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
    func didPerformSearch(results: [Listing])
}

final class SearchViewController: UIViewController {
    private let searchField: CustomTextField2 = {
        let textField = CustomTextField2()
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
    
    private let radiusField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.placeholder = "Enter radius"
        textField.isHidden = true
        return textField
    }()
    
    private let latLongContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let latLongButton: CustomSearchButton = {
        let button = CustomSearchButton()
        button.setTitle("Add Near or Lat&Long", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let latLongField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.placeholder = "near"
        textField.isHidden = true
        return textField
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    weak var delegate: SearchViewControllerDelegate?
    private var viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupBindings()
    }
    
    private func setupUI() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        radiusContainer.addArrangedSubview(radiusButton)
        radiusContainer.addArrangedSubview(radiusField)
        
        latLongContainer.addArrangedSubview(latLongButton)
        latLongContainer.addArrangedSubview(latLongField)
        
        let stackView = UIStackView(arrangedSubviews: [searchField, radiusContainer, latLongContainer])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let searchButton = CustomButton(title: "Search", backgroundColor: .black, textColor: .white, action: {
            self.performSearch()
        })
        
        let searchButtonHostingController = UIHostingController(rootView: searchButton)
        addChild(searchButtonHostingController)
        view.addSubview(searchButtonHostingController.view)
        
        searchButtonHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButtonHostingController.view.heightAnchor.constraint(equalToConstant: 52),
            searchButtonHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButtonHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButtonHostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        searchButtonHostingController.didMove(toParent: self)
    }
    
    private func setupActions() {
        let closeAction = UIAction { [weak self] _ in
            self?.didTapCloseButton()
        }
        closeButton.addAction(closeAction, for: .touchUpInside)
        
        radiusButton.addTarget(self, action: #selector(didTapRadiusButton), for: .touchUpInside)
        latLongButton.addTarget(self, action: #selector(didTapLatLongButton), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onListingsUpdate = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.delegate?.didPerformSearch(results: self.viewModel.listings)
            }
        }
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRadiusButton() {
        toggleTextField(radiusField)
    }
    
    @objc private func didTapLatLongButton() {
        toggleTextField(latLongField)
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
        let ll = latLongField.text
        
        viewModel.searchPlaces(query: query, radius: radius, near: ll)
    }
}

extension Notification.Name {
    static let searchPerformed = Notification.Name("searchPerformed")
}

#Preview {
    SearchViewController()
}
