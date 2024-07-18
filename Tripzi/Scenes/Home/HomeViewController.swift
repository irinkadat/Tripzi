//
//  HomeViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = HomeViewModel()
    private let searchBarHostingController = UIHostingController(rootView: SearchBar())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        addSearchBarTapGesture()
    }
    
    private func setupSearchBar() {
        addChild(searchBarHostingController)
        searchBarHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarHostingController.view)
        
        NSLayoutConstraint.activate([
            searchBarHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarHostingController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        searchBarHostingController.didMove(toParent: self)
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
            collectionView.topAnchor.constraint(equalTo: searchBarHostingController.view.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addSearchBarTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        searchBarHostingController.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapSearchBar() {
        let searchVC = SearchViewController()
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        let listing = viewModel.listings[indexPath.row]
        cell.configure(with: listing) {
            let destinationDetailsVC = DestinationDetailsVC()
            self.navigationController?.pushViewController(destinationDetailsVC, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationDetailsVC = DestinationDetailsVC()
        navigationController?.pushViewController(destinationDetailsVC, animated: true)
    }
}

#Preview {
    HomeViewController()
}
