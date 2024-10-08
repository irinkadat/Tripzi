//
//  FullScreenMapViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 19.07.24.
//

import UIKit
import SwiftUI

final class FullScreenMapViewController: UIViewController {
    
    // MARK: - Properties
    
    var latitude: Double
    var longitude: Double
    var locationName: String
    
    // MARK: - Initializers
    
    init(latitude: Double, longitude: Double, locationName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        setupMapView()
        setupBackButton()
    }
    
    private func setupMapView() {
        let mapLocation = MapLocation(latitude: latitude, longitude: longitude, name: locationName)
        let mapView = UIHostingController(rootView: MapView(locations: [mapLocation]))
        
        //        let mapView = UIHostingController(rootView: MapView(latitude: latitude, longitude: longitude, locationName: locationName))
        addChild(mapView)
        mapView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView.view)
        mapView.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            mapView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -120),
            mapView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 70)
        ])
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        let backImage = UIImage(systemName: "arrow.backward")
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .uniCo
        backButton.addAction(UIAction(handler: { _ in self.backButtonTapped() }), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    
    private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
