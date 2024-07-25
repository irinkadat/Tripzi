//
//  FavoritesViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import Combine
import SwiftUI

final class FavoritesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = FavoritesViewModel()
    private let emptyStateView = UIView()
    private let emptyStateLabel = UILabel()
    private let goToHomePageButton = UIButton(type: .system)
    private let illustrationImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButtonStyle()
        setupNavigation()
        setupCollectionView()
        setupEmptyStateView()
        setupBindings()
        viewModel.fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupNavigation() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupBindings() {
        viewModel.onFavoritesUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onFavoritesStateChange = { [weak self] hasFavorites in
            self?.emptyStateView.isHidden = hasFavorites
            self?.collectionView.isHidden = !hasFavorites
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        emptyStateLabel.text = "Oops! No favorites. Go to Explore."
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 18)
        
        illustrationImageView.image = UIImage(named: "favempty")
        illustrationImageView.contentMode = .scaleAspectFit
        
        goToHomePageButton.setTitle("Go to Explore", for: .normal)
        goToHomePageButton.addAction(UIAction(handler: { _ in self.goToHomePage() }), for: .touchUpInside)
        goToHomePageButton.tintColor = UIColor(named: "GreenPrimary")
        
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(illustrationImageView)
        emptyStateView.addSubview(goToHomePageButton)
        
        view.addSubview(emptyStateView)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
        goToHomePageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            illustrationImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            illustrationImageView.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            illustrationImageView.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            illustrationImageView.widthAnchor.constraint(equalToConstant: 200),
            illustrationImageView.heightAnchor.constraint(equalToConstant: 200),
            
            emptyStateLabel.topAnchor.constraint(equalTo: illustrationImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            goToHomePageButton.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 10),
            goToHomePageButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            goToHomePageButton.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    @objc private func goToHomePage() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    private func presentDetailViewController(listing: Listing, detailedListing: Listing, imageUrls: [String]) {
        let destinationDetailsVC = DestinationDetailsVC()
        let detailsViewModel = DetailsViewModel(listing: detailedListing, imageUrls: imageUrls)
        destinationDetailsVC.viewModel = detailsViewModel
        navigationController?.pushViewController(destinationDetailsVC, animated: false)
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        viewModel.configureCell(at: indexPath) { [weak self] listing, detailedListing, imageUrls in
            cell.configure(with: listing) {
                self?.presentDetailViewController(listing: listing, detailedListing: detailedListing, imageUrls: imageUrls)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath) { [weak self] listing, detailedListing, imageUrls in
            self?.presentDetailViewController(listing: listing, detailedListing: detailedListing, imageUrls: imageUrls)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 450)
    }
}
