//
//  DestinationDetailsVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit
import SwiftUI

final class DestinationDetailsVC: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var lastAddedView: UIView?
    var viewModel: DetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupScrollView() {
        [scrollView, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        addImageCarousel()
        addBasicInfo()
        addInfoStatsView()
        addLocationSection()
        addDivider()
        addWebsiteSection()
        addContactSection()
        addSection(title: "Cost", content: viewModel.paymentDescription())
        addDivider()
        addMapView(lat: viewModel.listingLatitude, long: viewModel.listingLongitude, locationName: viewModel.listingName)
        addTipCollectionView()
        lastAddedView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func addImageCarousel() {
        let hostingController = UIHostingController(rootView: ListingImageCarouselView(imageUrls: viewModel.imageUrls))
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -100),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 350)
        ])
        lastAddedView = hostingController.view
    }
    
    private func addBasicInfo() {
        let nameLabel = UILabel()
        nameLabel.text = viewModel.listingName
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let locationLabel = CustomLabel(style: .title, fontSize: 17)
        locationLabel.text = viewModel.listingLocation
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel, locationLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        lastAddedView = locationLabel
    }
    
    private func addMapView(lat: Double, long: Double, locationName: String) {
        addSection(title: "Where you will be", content: "")
        
        let mapView = UIHostingController(rootView: MapView(latitude: lat, longitude: long, locationName: locationName))
        addChild(mapView)
        mapView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapView.view)
        mapView.didMove(toParent: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.view.addGestureRecognizer(tapGesture)
        mapView.view.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            mapView.view.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            mapView.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mapView.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.view.heightAnchor.constraint(equalToConstant: 250)
        ])
        lastAddedView = mapView.view
    }
    
    @objc private func mapViewTapped() {
        let fullScreenMapVC = FullScreenMapViewController(latitude: viewModel.listingLatitude, longitude: viewModel.listingLongitude, locationName: viewModel.listingName)
        fullScreenMapVC.modalPresentationStyle = .fullScreen
        present(fullScreenMapVC, animated: true, completion: nil)
    }
    
    private func addWebsiteSection() {
        guard let website = viewModel.listingWebsite else { return }
        addSection(title: "Website", content: website, iconName: "globe")
    }
    
    private func addSection(title: String, content: String, iconName: String? = nil) {
        let titleLabel = CustomLabel(style: .title, fontSize: 16)
        titleLabel.text = title
        
        let contentLabel = CustomLabel(style: .subtitle, fontSize: 15)
        contentLabel.text = content
        
        [titleLabel, contentLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        lastAddedView = contentLabel
    }
    
    private func addInfoStatsView() {
        let infoStatsView = InfoStatsView()
        infoStatsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoStatsView)
        
        let openStatusColor: UIColor = viewModel.listingOpenStatus == "Open Now" ? .systemGreen.withAlphaComponent(0.7) : .systemRed
        
        infoStatsView.configure(
            rating: viewModel.listingRating,
            openStatus: viewModel.listingOpenStatus,
            openStatusColor: openStatusColor,
            checkins: viewModel.listingCheckins
        )
        
        NSLayoutConstraint.activate([
            infoStatsView.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 10),
            infoStatsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStatsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        lastAddedView = infoStatsView
    }
    
    private func addDivider() {
        let divider = UIView()
        divider.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        lastAddedView = divider
    }
    
    private func addLocationSection() {
        addSection(title: "Location", content: viewModel.listingLocationAddress)
    }
    
    private func addContactSection() {
        guard let contact = viewModel.listingContact else { return }
        addSection(title: "Contact Information", content: contact.formattedPhone, iconName: "phone")
        addSection(title: "", content: contact.instagram, iconName: "insta")
    }
    
    private func addTipCollectionView() {
        addSection(title: "Tips & Reviews", content: "")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 26
        
        let tipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tipCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tipCollectionView.backgroundColor = .white
        tipCollectionView.register(TipCardCollectionViewCell.self, forCellWithReuseIdentifier: "TipCardCollectionViewCell")
        tipCollectionView.dataSource = self
        tipCollectionView.delegate = self
        contentView.addSubview(tipCollectionView)
        
        NSLayoutConstraint.activate([
            tipCollectionView.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            tipCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tipCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tipCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        lastAddedView = tipCollectionView
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension DestinationDetailsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(viewModel.tips.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipCardCollectionViewCell", for: indexPath) as? TipCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tipItem = viewModel.tips[indexPath.item]
        cell.configure(tipText: tipItem.text, UserName: tipItem.user?.firstName ?? "", likes: String(tipItem.agreeCount), dislikes: String(tipItem.disagreeCount), userImage: UIImage(named: "user")!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
}
