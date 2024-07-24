//
//  AboutVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 24.07.24.
//

import UIKit

final class AboutVC: UIViewController {
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Welcome to Tripzi!
        
        Tripzi is a comprehensive travel application designed to make your travel planning seamless and enjoyable. Whether you're looking to explore new destinations or find the best flights, Tripzi has got you covered.
        
        Our app offers a wide range of features to help you plan your perfect trip:
        
        * Explore Places: Discover beautiful places around the world. From iconic landmarks to hidden gems, Tripzi provides detailed information, photos, and reviews to help you choose your next adventure.
        
        * Find Flights: Search and compare flights from various airlines to find the best deals. Our intuitive search functionality allows you to filter flights by price, duration, and airline, ensuring you find the perfect flight for your budget and schedule.
        
        * Plan Your Itinerary: Create and manage your travel itinerary with ease. Add flights, accommodation, and activities to your itinerary and keep everything organised in one place.
        
        * Travel Guides: Access comprehensive travel guides for top destinations. Get insights on local attractions, cuisine, culture, and more to make the most of your trip.
        
        Thank you for choosing Tripzi. We wish you happy and safe travels!
        
        The Tripzi Team
        """
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButtonStyle()
        view.backgroundColor = .white
        configureNavigationBarTitle(title: "About Us")
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(aboutLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            aboutLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            aboutLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

#Preview {
    ProfileVC()
}
