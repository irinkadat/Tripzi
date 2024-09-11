//
//  HomeViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import SwiftUI
import CoreLocation
import MapKit

final class HomeViewController: UIViewController {
    // MARK: - Properties
    
    private var categoryViewController: CategoryViewController!
    private var listingsViewController: ListingsViewController!
    private let viewModel = SearchViewModel()
    private let customSearchBar = CustomSearchBar()
    private let locationManager = CLLocationManager()
    private let containerView = UIView()
    private let mapToggleButton = UIButton()
    private var mapViewController: UIHostingController<MapView>!
    private var stackView = UIStackView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Go back to Places"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .uniCo
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let mapIcon = UIImage(systemName: "map")
        let iconImageView = UIImageView(image: mapIcon)
        iconImageView.tintColor = UIColor(named: "UniModal")
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSearchBarTapGesture()
        updateListingBasedUserLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupUI() {
        setupCustomSearchBar()
        setupCategoryViewController()
        setupMapView()
        setupListingsViewController()
        setupMapToggleButton()
        setupBindings()
        setupTitleLabelTapGesture()
        setupCustomBackButtonStyle()
    }
    
    private func setupBindings() {
        viewModel.onMapLocationsUpdate = { [weak self] mapLocations in
            self?.mapViewController?.rootView.locations = mapLocations
        }
    }
    
    private func setupMapView() {
        mapViewController = UIHostingController(rootView: MapView(locations: viewModel.mapLocations))
        addChild(mapViewController)
        view.insertSubview(mapViewController.view, at: 0)
        mapViewController.didMove(toParent: self)
        
        mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapViewController.view.topAnchor.constraint(equalTo: categoryViewController.view.bottomAnchor, constant: 6),
            mapViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupListingsViewController() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.backgroundColor = UIColor(named: "UniBackground")
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 40
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: categoryViewController.view.bottomAnchor, constant: -56),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupStackView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideListingsBackUp))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true
        
        listingsViewController = ListingsViewController()
        listingsViewController.viewModel = viewModel
        addChild(listingsViewController)
        containerView.addSubview(listingsViewController.view)
        listingsViewController.didMove(toParent: self)
        listingsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listingsViewController.view.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 26),
            listingsViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            listingsViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            listingsViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        view.insertSubview(containerView, belowSubview: categoryViewController.view)
        
        listingsViewController.didSelectListing = { [weak self] detailedListing, imageUrls in
            guard let self = self else { return }
            let destinationDetailsVC = DestinationDetailsVC()
            let detailsViewModel = DetailsViewModel(listing: detailedListing, imageUrls: imageUrls)
            destinationDetailsVC.viewModel = detailsViewModel
            self.navigationController?.pushViewController(destinationDetailsVC, animated: true)
        }
    }
    
    func setupStackView() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .uniCo
        
        titleLabel.text = "Go back to Places"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let emptyView = UIView()
        let emptyView2 = UIView()
        emptyView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        
        stackView = UIStackView(arrangedSubviews: [emptyView, backButton, titleLabel, emptyView2])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 14),
            backButton.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -6),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTitleLabelTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideListingsBackUp))
        titleLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupMapToggleButton() {
        mapToggleButton.backgroundColor = UIColor(named: "CustomBlack")
        mapToggleButton.layer.cornerRadius = 22
        mapToggleButton.clipsToBounds = true
        mapToggleButton.isUserInteractionEnabled = true
        mapToggleButton.isHidden = true
        
        let titleLabel = UILabel()
        titleLabel.text = "Map"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = UIColor(named: "UniModal")
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, iconImageView])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        mapToggleButton.addSubview(stackView)
        mapToggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapToggleButton)
        
        setupMapButtonConstraints(stackView: stackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMapView))
        mapToggleButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupMapButtonConstraints(stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: mapToggleButton.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: mapToggleButton.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: mapToggleButton.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: mapToggleButton.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            mapToggleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mapToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapToggleButton.widthAnchor.constraint(equalToConstant: 98),
            mapToggleButton.heightAnchor.constraint(equalToConstant: 44)
        ])
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
        categoryViewController = CategoryViewController(viewModel: viewModel)
        addChild(categoryViewController)
        view.addSubview(categoryViewController.view)
        categoryViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryViewController.view.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 20),
            categoryViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categoryViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryViewController.view.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addSearchBarTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        customSearchBar.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action Methods
    
    @objc private func toggleMapView() {
        if !viewModel.isMapVisible {
            UIView.animate(withDuration: 0.5) {
                self.tabBarController?.tabBar.isHidden = true
                self.containerView.frame.origin.y = self.view.frame.height * 0.93
                self.mapToggleButton.isHidden = true
            }
            viewModel.isMapVisible = true
            
        } else {
            slideListingsBackUp()
        }
    }
    
    @objc private func didTapSearchBar() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
    
    @objc private func slideListingsBackUp() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.frame.origin.y = self.categoryViewController.view.frame.maxY - 56
        }
        
        self.tabBarController?.tabBar.isHidden = false
        viewModel.isMapVisible = false
        mapToggleButton.isHidden = false
    }
    
    // MARK: - Helper Methods
    
    private func updateListingBasedUserLocation() {
        viewModel.onListingsUpdate = { [weak self] in
            guard let self = self else { return }
            self.listingsViewController.collectionView.reloadData()
            mapToggleButton.isHidden = false
        }
        viewModel.checkLocationAuthorization()
    }
}

// MARK: - SearchViewControllerDelegate

extension HomeViewController: SearchViewControllerDelegate {
    func didPerformSearch(results: [PlaceListing]) {
        viewModel.listings = results
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewModel.handleAuthorizationStatus(manager: manager)
    }
}
