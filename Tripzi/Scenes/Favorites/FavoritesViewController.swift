//
//  FavoritesViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

//import UIKit
//import Combine
//import SwiftUI
//
//class FavoritesViewController: UIViewController {
//    private var collectionView: UICollectionView!
//    private var viewModel = FavoritesViewModel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupNavigation()
//        setupCollectionView()
//        viewModel.fetchFavorites()
//        
//        viewModel.$favorites.sink { [weak self] listings in
//            self?.collectionView.reloadData()
//        }.store(in: &cancellables)
//    }
//    
//    private func setupNavigation() {
//        title = "Favorites"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
//    }
//    
//    private func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumLineSpacing = 20
//        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
//        
//        view.addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private var cancellables = Set<AnyCancellable>()
//}
//
//extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.favorites.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
//        let listing = viewModel.favorites[indexPath.row]
//        
//        cell.configure(with: listing) { [weak self] in
//            guard let self = self else { return }
//            let detailVM = SearchViewModel()
//            detailVM.destinationDetails(for: listing.id) { detailedListing in
//                guard let detailedListing = detailedListing else { return }
//                DispatchQueue.main.async {
//                    let destinationDetailsVC = DestinationDetailsVC()
//                    destinationDetailsVC.listing = detailedListing
//                    destinationDetailsVC.imageUrls = listing.imageUrls
//                    self.navigationController?.pushViewController(destinationDetailsVC, animated: true)
//                }
//            }
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 450)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let listing = viewModel.favorites[indexPath.row]
//        let destinationDetailsVC = DestinationDetailsVC()
//        destinationDetailsVC.listing = listing
//        navigationController?.pushViewController(destinationDetailsVC, animated: true)
//    }
//}
//
//#Preview {
//    FavoritesViewController()
//}


import UIKit
import Combine
import SwiftUI

final class FavoritesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = FavoritesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupCollectionView()
        viewModel.fetchFavorites()
        
        viewModel.$favorites.sink { [weak self] listings in
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func setupNavigation() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        let listing = viewModel.favorites[indexPath.row]
        
        cell.configure(with: listing) { [weak self] in
            guard let self = self else { return }
            let detailVM = SearchViewModel()
            detailVM.destinationDetails(for: listing.id) { detailedListing in
                guard let detailedListing = detailedListing else { return }
                DispatchQueue.main.async {
                    let destinationDetailsVC = DestinationDetailsVC()
                    destinationDetailsVC.listing = detailedListing
                    destinationDetailsVC.imageUrls = listing.imageUrls
                    self.navigationController?.pushViewController(destinationDetailsVC, animated: true)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listing = viewModel.favorites[indexPath.row]
        let destinationDetailsVC = DestinationDetailsVC()
        destinationDetailsVC.listing = listing
        navigationController?.pushViewController(destinationDetailsVC, animated: true)
    }
}
