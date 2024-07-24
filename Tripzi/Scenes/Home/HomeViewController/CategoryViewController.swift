//
//  CategoryViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 24.07.24.
//

import UIKit

final class CategoryViewController: UIViewController {
    private var collectionView: UICollectionView!
    static let categories: [SearchCategory] = [
        SearchCategory(name: "Hotel", icon: (UIImage(named: "hotel") ?? UIImage(named: "pic"))!),
        SearchCategory(name: "food", icon: UIImage(named: "burger") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Stores", icon: UIImage(named: "store") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Bar", icon: (UIImage(named: "vodka") ?? UIImage(named: "pic"))!),
        SearchCategory(name: "Coffee", icon: UIImage(named: "cup") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Museums", icon: UIImage(named: "museum") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Night Clubs", icon: UIImage(named: "fire") ?? UIImage(named: "pic")!),
        SearchCategory(name: "music", icon: UIImage(named: "music") ?? UIImage(named: "pic")!)
    ]
    var didSelectCategory: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryViewController.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        let category = CategoryViewController.categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCategory?(CategoryViewController.categories[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 70)
    }
}
