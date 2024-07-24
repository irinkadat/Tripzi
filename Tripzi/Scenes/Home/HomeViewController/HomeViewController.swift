//
//  HomeViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import Combine
import SwiftUI

final class HomeViewController: UIViewController {
    private var categoryViewController: CategoryViewController!
    private var listingsViewController: ListingsViewController!
    private let viewModel = SearchViewModel()
    private let customSearchBar = CustomSearchBar()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomSearchBar()
        setupCategoryViewController()
        setupListingsViewController()
        addSearchBarTapGesture()
        setupCustomBackButtonStyle()
        
        viewModel.fetchDefaultListings()
    }
    
    private func setupCustomSearchBar() {
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customSearchBar)
        
        NSLayoutConstraint.activate([
            customSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            customSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customSearchBar.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupCategoryViewController() {
        categoryViewController = CategoryViewController()
        addChild(categoryViewController)
        view.addSubview(categoryViewController.view)
        categoryViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryViewController.view.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 20),
            categoryViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryViewController.view.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        categoryViewController.didSelectCategory = { [weak self] category in
            self?.viewModel.fetchListings(for: category)
        }
    }
    
    private func setupListingsViewController() {
        listingsViewController = ListingsViewController()
        listingsViewController.viewModel = viewModel
        addChild(listingsViewController)
        view.addSubview(listingsViewController.view)
        listingsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listingsViewController.view.topAnchor.constraint(equalTo: categoryViewController.view.bottomAnchor),
            listingsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listingsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listingsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        listingsViewController.didSelectListing = { [weak self] detailedListing, imageUrls in
            guard let self = self else { return }
            let destinationDetailsVC = DestinationDetailsVC()
            let detailsViewModel = DetailsViewModel(listing: detailedListing, imageUrls: imageUrls)
            destinationDetailsVC.viewModel = detailsViewModel
            self.navigationController?.pushViewController(destinationDetailsVC, animated: true)
        }
    }
    
    private func addSearchBarTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        customSearchBar.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapSearchBar() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
}

extension HomeViewController: SearchViewControllerDelegate {
    func didPerformSearch(results: [Listing]) {
        viewModel.listings = results
    }
}

#Preview {
    HomeViewController()
}
