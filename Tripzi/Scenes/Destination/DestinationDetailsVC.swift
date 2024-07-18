//
//  DestinationDetailsVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit
import SwiftUI

class DestinationDetailsVC: UIViewController {
    var listing: Listing?
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var lastAddedView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let listing = listing else { return }
        
        setupScrollView()
        setupUI(with: listing)
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    private func setupUI(with listing: Listing) {
        addImageCarousel(with: listing.imageUrls)
        addBasicInfo(with: listing)
        addInfoStatsView(with: listing)
        addLocationSection(with: listing)
        addDivider()
        addWebsiteSection(with: listing.description)
        addContactSection(with: listing)
        addDivider()
        addSection(title: "Cost", content: paymentDescription(listing.price))
        
        if let lastAddedView = lastAddedView {
            NSLayoutConstraint.activate([
                lastAddedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
    }
    
    private func addImageCarousel(with imageUrls: [String]) {
        let hostingController = UIHostingController(rootView: ListingImageCarouselView(imageUrls: imageUrls))
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -200),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 230)
        ])
        
        lastAddedView = hostingController.view
    }
    
    private func addBasicInfo(with listing: Listing) {
        let nameLabel = UILabel()
        nameLabel.text = listing.name
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let locationLabel = CustomLabel(style: .title, fontSize: 17)
        locationLabel.text = listing.location
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        let reviewTxt = CustomLabel(style: .subtitle, fontSize: 15)
//        reviewTxt.text = listing.header
//        reviewTxt.numberOfLines = 2
//        reviewTxt.translatesAutoresizingMaskIntoConstraints = false
        
//        let infoStackView = UIStackView(arrangedSubviews: [locationLabel])
//        infoStackView.axis = .vertical
//        infoStackView.spacing = 10
//        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        
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
    
    private func addWebsiteSection(with website: String?) {
        guard let website = website else { return }
        
        let sectionTitle = CustomLabel(style: .title, fontSize: 16)
        sectionTitle.text = "Website"
        contentView.addSubview(sectionTitle)
        
        let websiteStackView = IconTextStackView(icon: UIImage(named: "globe"), text: website)
        contentView.addSubview(websiteStackView)
        
        NSLayoutConstraint.activate([
            sectionTitle.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            sectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            websiteStackView.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 10),
            websiteStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            websiteStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        lastAddedView = websiteStackView
    }
    
    private func addSection(title: String, content: String) {
        let titleLabel = CustomLabel(style: .title, fontSize: 16)
        titleLabel.text = title
        
        let contentLabel = CustomLabel(style: .subtitle, fontSize: 15)
        contentLabel.text = content
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        lastAddedView = contentLabel
    }
    
    private func addInfoStatsView(with listing: Listing) {
        let infoStatsView = InfoStatsView()
        infoStatsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoStatsView)
        
        infoStatsView.configure(
            rating: String(format: "%.2f", listing.rating),
            openStatus: listing.isOpen == true ? "Closed" : "Open Now",
            openStatusColor: listing.isOpen == true ? .systemRed : .systemGreen.withAlphaComponent(0.7),
            checkins: "\(listing.stats?.checkinsCount ?? 0)"
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
    
    private func addLocationSection(with listing: Listing) {
        addSection(title: "Location", content: "\(listing.location ?? ""), \(listing.address)")
    }
    
    private func addContactSection(with listing: Listing) {
        guard let contact = listing.contact else { return }
        
        let sectionTitle = CustomLabel(style: .title, fontSize: 16)
        sectionTitle.text = "Contact Information"
        contentView.addSubview(sectionTitle)
        
        let phoneStackView = IconTextStackView(icon: UIImage(named: "phone"), text: contact.phone)
        let instagramStackView = IconTextStackView(icon: UIImage(named: "insta"), text: contact.instagram)
        
        contentView.addSubview(phoneStackView)
        contentView.addSubview(instagramStackView)
        
        NSLayoutConstraint.activate([
            sectionTitle.topAnchor.constraint(equalTo: lastAddedView?.bottomAnchor ?? contentView.topAnchor, constant: 20),
            sectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            phoneStackView.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 10),
            phoneStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instagramStackView.topAnchor.constraint(equalTo: phoneStackView.bottomAnchor, constant: 10),
            instagramStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instagramStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        lastAddedView = instagramStackView
    }
    
    private func paymentDescription(_ payment: Price?) -> String {
        guard let payment = payment else { return "No cost information available." }
        let tier = payment.tier
        let message = payment.message
        let currency = payment.currency
        return """
        Tier: \(tier)
        Cost: \(message)
        Currency: \(currency)
        """
    }
}

#Preview {
    DestinationDetailsVC()
}
