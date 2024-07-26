//
//  SearchViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Combine
import Foundation
import NetService
import CoreLocation

protocol SearchViewModelDelegate: AnyObject {
    func didReceiveValidationMessage(_ message: String)
}

final class SearchViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var selectedCategoryIndex: Int? {
        didSet {
            guard let selectedIndex = selectedCategoryIndex else { return }
            let category = CategoryViewController.categories[selectedIndex].name
            fetchListings(for: category)
        }
    }
    
    weak var delegate: SearchViewModelDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var detailedPlace: Listing?
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var locationError: String?
    var onListingsUpdate: (() -> Void)?
    var onCategoryIndexChanged: ((Int?) -> Void)?
    private let networkService = NetworkService()
    var locationManager: LocationManager
    
    private let defaultLatitude = 45.464664
    private let defaultLongitude = 9.188540
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        bindUI()
    }
    
    private func bindUI() {
        $selectedCategoryIndex
            .sink { [weak self] index in
                self?.onCategoryIndexChanged?(index)
            }
            .store(in: &cancellables)
        
        $listings
            .sink { [weak self] listings in
                self?.onListingsUpdate?()
                self?.postSearchNotification(with: listings)
            }
            .store(in: &cancellables)
        
        $latitude
            .combineLatest($longitude)
            .sink { [weak self] latitude, longitude in
                guard longitude != nil else { return }
                self?.fetchLocalListings(usingDefaultLocation: false)
            }
            .store(in: &cancellables)
    }
    
    private func observeLocationAuthorization() {
        locationManager.authorizationChanged = { [weak self] status in
            self?.handleLocationAuthorization(status: status)
        }
    }
    
    func checkLocationAuthorization() {
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.handleLocationAuthorization(status: LocationManager.authorizationStatus())
                }
            } else {
                DispatchQueue.main.async {
                    self.locationError = "Location services are not enabled."
                    self.fetchLocalListings(usingDefaultLocation: true)
                }
            }
        }
    }
    
    func handleLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestCurrentLocation { [weak self] result in
                switch result {
                case .success(let coordinate):
                    self?.latitude = coordinate.latitude
                    self?.longitude = coordinate.longitude
                case .failure(let error):
                    self?.locationError = error.localizedDescription
                    self?.fetchLocalListings(usingDefaultLocation: true)
                }
            }
        case .restricted, .denied:
            locationError = "Location services are disabled."
            fetchLocalListings(usingDefaultLocation: true)
        case .authorizedAlways, .authorizedWhenInUse:
            fetchCurrentLocation()
        @unknown default:
            break
        }
    }
    
    func handleAuthorizationStatus(manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                checkLocationAuthorization()
                if let location = manager.location {
                    searchNearbyPlaces(location: location)
                }
            case .denied, .restricted, .notDetermined:
                break
            @unknown default:
                break
            }
        }
    
    func searchNearbyPlaces(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        searchPlaces(query: "hotel", radius: nil, near: "\(latitude),\(longitude)")
    }
    
    func fetchCurrentLocation() {
        locationManager.requestCurrentLocation { [weak self] result in
            switch result {
            case .success(let coordinate):
                self?.latitude = coordinate.latitude
                self?.longitude = coordinate.longitude
            case .failure(let error):
                self?.locationError = error.localizedDescription
                self?.fetchLocalListings(usingDefaultLocation: true)
            }
        }
    }
    
    private func postSearchNotification(with listings: [Listing]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .searchPerformed, object: nil, userInfo: ["results": listings])
        }
    }
    
    func searchPlaces(query: String?, radius: Int?, near: String?) {
        guard let near = near, !near.isEmpty else {
            delegate?.didReceiveValidationMessage("Please enter a location in the 'near' field.")
            return
        }
        
        var components = URLComponents(string: "https://api.foursquare.com/v2/search/recommendations")!
        
        var queryItems = [
            URLQueryItem(name: "v", value: "20231010"),
            URLQueryItem(name: "oauth_token", value: "QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP")
        ]
        
        if let query = query {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        
        if let radius = radius {
            queryItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
        }
        
        queryItems.append(URLQueryItem(name: "near", value: near))
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("Failed to construct URL")
            return
        }
                
        networkService.getData(urlString: url.absoluteString) { (result: Result<PlacesResponse, Error>) in
            switch result {
            case .success(let decodedData):
                let results = decodedData.response.group?.results ?? decodedData.response.results ?? []
                DispatchQueue.main.async {
                    let sortedResults = results.sorted { (place1, place2) -> Bool in
                        let hasPhotos1 = (place1.photos?.groups?.first?.items.isEmpty == false)
                        let hasPhotos2 = (place2.photos?.groups?.first?.items.isEmpty == false)
                        return hasPhotos1 && !hasPhotos2
                    }
                    
                    self.listings = sortedResults.compactMap { place in
                        return Listing(from: place)
                    }
                }
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
    }
    
    func configureCategoryCell(at indexPath: IndexPath, completion: @escaping (SearchCategory) -> Void) {
        let category = CategoryViewController.categories[indexPath.row]
        completion(category)
    }
    
    func configureListingCell(at indexPath: IndexPath, completion: @escaping (Listing, Listing, [String]) -> Void) {
        let listing = listings[indexPath.row]
        destinationDetails(for: listing.id) { detailedListing in
            guard let detailedListing = detailedListing else { return }
            completion(listing, detailedListing, listing.imageUrls)
        }
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
    }
    
    func didSelectListing(at indexPath: IndexPath, completion: @escaping (Listing, [String]) -> Void) {
        let listing = listings[indexPath.row]
        destinationDetails(for: listing.id) { detailedListing in
            guard let detailedListing = detailedListing else { return }
            completion(detailedListing, listing.imageUrls)
        }
    }
    
    func fetchListings(for category: String?) {
        searchPlaces(query: category, radius: nil, near: "\(self.latitude ?? defaultLatitude), \(self.longitude ?? defaultLongitude)")
    }
    
    func fetchLocalListings(usingDefaultLocation: Bool = false) {
        if usingDefaultLocation {
            searchPlaces(query: nil, radius: nil, near: "\(defaultLatitude), \(defaultLongitude)")
        } else {
            searchPlaces(query: "hotel", radius: nil, near: "\(self.latitude ?? defaultLatitude), \(self.longitude ?? defaultLongitude)")
        }
    }
    
    func tierDescription(for tier: Int) -> String {
        switch tier {
        case 1:
            return "Affordable"
        case 2:
            return "Moderate"
        case 3:
            return "Expensive"
        default:
            return "Unknown"
        }
    }
    
    func destinationDetails(for id: String, completion: @escaping (Listing?) -> Void) {
        let urlString = "https://api.foursquare.com/v2/venues/\(id)?v=20231010&oauth_token=QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP"
        
        networkService.getData(urlString: urlString) { (result: Result<DetailedVenueResponse, Error>) in
            switch result {
            case .success(let decodedData):
                if let venueDetail = decodedData.response.venue {
                    let placeResult = PlaceResult(displayType: "venue", venue: venueDetail, photos: venueDetail.photos)
                    let listing = Listing(from: placeResult)
                    
                    DispatchQueue.main.async {
                        self.detailedPlace = listing
                        completion(listing)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }
    }
}
