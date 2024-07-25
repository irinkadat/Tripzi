//
//  SearchViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

//import Combine
//import Foundation
//import NetService
//
//final class SearchViewModel: ObservableObject {
//    @Published var listings: [Listing] = []
//    private var cancellables: Set<AnyCancellable> = []
//    @Published var detailedPlace: Listing?
//    var onListingsUpdate: (() -> Void)?
//    private let networkService = NetworkService()
//    
//    init() {
//        bindUI()
//    }
//    
//    private func bindUI() {
//        $listings
//            .sink { [weak self] listings in
//                self?.onListingsUpdate?()
//                self?.postSearchNotification(with: listings)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func postSearchNotification(with listings: [Listing]) {
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: .searchPerformed, object: nil, userInfo: ["results": listings])
//        }
//    }
//    
//    func searchPlaces(query: String?, radius: Int?, near: String?) {
//        var components = URLComponents(string: "https://api.foursquare.com/v2/search/recommendations")!
//        
//        var queryItems = [
//            URLQueryItem(name: "v", value: "20231010"),
//            URLQueryItem(name: "oauth_token", value: "QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP")
//        ]
//        
//        if let query = query {
//            queryItems.append(URLQueryItem(name: "query", value: query))
//        }
//        
//        if let radius = radius {
//            queryItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
//        }
//        
//        if let near = near {
//            queryItems.append(URLQueryItem(name: "near", value: near))
//        } else {
//            queryItems.append(URLQueryItem(name: "near", value: "Tbilisi"))
//        }
//        
//        components.queryItems = queryItems
//        
//        guard let url = components.url else {
//            print("Failed to construct URL")
//            return
//        }
//        
//        print("Request URL: \(url)")
//        
//        networkService.getData(urlString: url.absoluteString) { (result: Result<PlacesResponse, Error>) in
//            switch result {
//            case .success(let decodedData):
//                let results = decodedData.response.group?.results ?? decodedData.response.results ?? []
//                DispatchQueue.main.async {
//                    let sortedResults = results.sorted { (place1, place2) -> Bool in
//                        let hasPhotos1 = (place1.photos?.groups?.first?.items.isEmpty == false)
//                        let hasPhotos2 = (place2.photos?.groups?.first?.items.isEmpty == false)
//                        return hasPhotos1 && !hasPhotos2
//                    }
//                    
//                    self.listings = sortedResults.compactMap { place in
//                        return Listing(from: place)
//                    }
//                    print("Search results fetched: \(self.listings.count)")
//                }
//            case .failure(let error):
//                print("Error occurred: \(error)")
//            }
//        }
//    }
//    
//    func configureCategoryCell(at indexPath: IndexPath, completion: @escaping (SearchCategory) -> Void) {
//        let category = CategoryViewController.categories[indexPath.row]
//        completion(category)
//    }
//    
//    func configureListingCell(at indexPath: IndexPath, completion: @escaping (Listing, Listing, [String]) -> Void) {
//        let listing = listings[indexPath.row]
//        destinationDetails(for: listing.id) { detailedListing in
//            guard let detailedListing = detailedListing else { return }
//            completion(listing, detailedListing, listing.imageUrls)
//        }
//    }
//    
//    func didSelectCategory(at indexPath: IndexPath) {
//        let category = CategoryViewController.categories[indexPath.row].name
//        fetchListings(for: category)
//    }
//    
//    func didSelectListing(at indexPath: IndexPath, completion: @escaping (Listing, [String]) -> Void) {
//        let listing = listings[indexPath.row]
//        destinationDetails(for: listing.id) { detailedListing in
//            guard let detailedListing = detailedListing else { return }
//            completion(detailedListing, listing.imageUrls)
//        }
//    }
//    
//    func fetchListings(for category: String?) {
//        let defaultCity = "Milan"
//        searchPlaces(query: category, radius: nil, near: defaultCity)
//    }
//    
//    func fetchLocalListings() {
//        let defaultCity = "Milan"
//        searchPlaces(query: "stores", radius: nil, near: defaultCity)
//    }
//    
//    func tierDescription(for tier: Int) -> String {
//        switch tier {
//        case 1:
//            return "Affordable"
//        case 2:
//            return "Moderate"
//        case 3:
//            return "Expensive"
//        default:
//            return "Unknown"
//        }
//    }
//    
//    func destinationDetails(for id: String, completion: @escaping (Listing?) -> Void) {
//        let urlString = "https://api.foursquare.com/v2/venues/\(id)?v=20231010&oauth_token=QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP"
//        
//        networkService.getData(urlString: urlString) { (result: Result<DetailedVenueResponse, Error>) in
//            switch result {
//            case .success(let decodedData):
//                if let venueDetail = decodedData.response.venue {
//                    let placeResult = PlaceResult(displayType: "venue", venue: venueDetail, photos: venueDetail.photos)
//                    let listing = Listing(from: placeResult)
//                    
//                    DispatchQueue.main.async {
//                        self.detailedPlace = listing
//                        completion(listing)
//                    }
//                } else {
//                    completion(nil)
//                }
//            case .failure(let error):
//                print("Failed to decode JSON: \(error)")
//                completion(nil)
//            }
//        }
//    }
//}


//import Combine
//import Foundation
//import NetService
//
//final class SearchViewModel: ObservableObject {
//    @Published var listings: [Listing] = []
//    @Published var selectedCategoryIndex: Int?
//    private var cancellables: Set<AnyCancellable> = []
//    @Published var detailedPlace: Listing?
//    var onListingsUpdate: (() -> Void)?
//    private let networkService = NetworkService()
//    
//    init() {
//        bindUI()
//    }
//    
//    private func bindUI() {
//        $listings
//            .sink { [weak self] listings in
//                self?.onListingsUpdate?()
//                self?.postSearchNotification(with: listings)
//            }
//            .store(in: &cancellables)
//        
//        $selectedCategoryIndex
//            .sink { [weak self] index in
//                guard let self = self, let index = index else { return }
//                let category = CategoryViewController.categories[index].name
//                self.fetchListings(for: category)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func postSearchNotification(with listings: [Listing]) {
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: .searchPerformed, object: nil, userInfo: ["results": listings])
//        }
//    }
//    
//    func searchPlaces(query: String?, radius: Int?, near: String?) {
//        var components = URLComponents(string: "https://api.foursquare.com/v2/search/recommendations")!
//        
//        var queryItems = [
//            URLQueryItem(name: "v", value: "20231010"),
//            URLQueryItem(name: "oauth_token", value: "QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP")
//        ]
//        
//        if let query = query {
//            queryItems.append(URLQueryItem(name: "query", value: query))
//        }
//        
//        if let radius = radius {
//            queryItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
//        }
//        
//        if let near = near {
//            queryItems.append(URLQueryItem(name: "near", value: near))
//        } else {
//            queryItems.append(URLQueryItem(name: "near", value: "Tbilisi"))
//        }
//        
//        components.queryItems = queryItems
//        
//        guard let url = components.url else {
//            print("Failed to construct URL")
//            return
//        }
//        
//        print("Request URL: \(url)")
//        
//        networkService.getData(urlString: url.absoluteString) { (result: Result<PlacesResponse, Error>) in
//            switch result {
//            case .success(let decodedData):
//                let results = decodedData.response.group?.results ?? decodedData.response.results ?? []
//                DispatchQueue.main.async {
//                    let sortedResults = results.sorted { (place1, place2) -> Bool in
//                        let hasPhotos1 = (place1.photos?.groups?.first?.items.isEmpty == false)
//                        let hasPhotos2 = (place2.photos?.groups?.first?.items.isEmpty == false)
//                        return hasPhotos1 && !hasPhotos2
//                    }
//                    
//                    self.listings = sortedResults.compactMap { place in
//                        return Listing(from: place)
//                    }
//                    print("Search results fetched: \(self.listings.count)")
//                }
//            case .failure(let error):
//                print("Error occurred: \(error)")
//            }
//        }
//    }
//    
//    func configureCategoryCell(at indexPath: IndexPath, completion: @escaping (SearchCategory) -> Void) {
//        let category = CategoryViewController.categories[indexPath.row]
//        completion(category)
//    }
//    
//    func configureListingCell(at indexPath: IndexPath, completion: @escaping (Listing, Listing, [String]) -> Void) {
//        let listing = listings[indexPath.row]
//        destinationDetails(for: listing.id) { detailedListing in
//            guard let detailedListing = detailedListing else { return }
//            completion(listing, detailedListing, listing.imageUrls)
//        }
//    }
//    
//    func didSelectCategory(at indexPath: IndexPath) {
//        selectedCategoryIndex = indexPath.row
//    }
//    
//    func didSelectListing(at indexPath: IndexPath, completion: @escaping (Listing, [String]) -> Void) {
//        let listing = listings[indexPath.row]
//        destinationDetails(for: listing.id) { detailedListing in
//            guard let detailedListing = detailedListing else { return }
//            completion(detailedListing, listing.imageUrls)
//        }
//    }
//    
//    func fetchListings(for category: String?) {
//        let defaultCity = "Milan"
//        searchPlaces(query: category, radius: nil, near: defaultCity)
//    }
//    
//    func fetchLocalListings() {
//        let defaultCity = "Milan"
//        searchPlaces(query: "stores", radius: nil, near: defaultCity)
//    }
//    
//    func tierDescription(for tier: Int) -> String {
//        switch tier {
//        case 1:
//            return "Affordable"
//        case 2:
//            return "Moderate"
//        case 3:
//            return "Expensive"
//        default:
//            return "Unknown"
//        }
//    }
//    
//    func destinationDetails(for id: String, completion: @escaping (Listing?) -> Void) {
//        let urlString = "https://api.foursquare.com/v2/venues/\(id)?v=20231010&oauth_token=QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP"
//        
//        networkService.getData(urlString: urlString) { (result: Result<DetailedVenueResponse, Error>) in
//            switch result {
//            case .success(let decodedData):
//                if let venueDetail = decodedData.response.venue {
//                    let placeResult = PlaceResult(displayType: "venue", venue: venueDetail, photos: venueDetail.photos)
//                    let listing = Listing(from: placeResult)
//                    
//                    DispatchQueue.main.async {
//                        self.detailedPlace = listing
//                        completion(listing)
//                    }
//                } else {
//                    completion(nil)
//                }
//            case .failure(let error):
//                print("Failed to decode JSON: \(error)")
//                completion(nil)
//            }
//        }
//    }
//}


//import Combine
//import Foundation
//import NetService
//
//final class SearchViewModel: ObservableObject {
//    @Published var listings: [Listing] = []
//    @Published var selectedCategoryIndex: Int?
//    private var cancellables: Set<AnyCancellable> = []
//    @Published var detailedPlace: Listing?
//    var onListingsUpdate: (() -> Void)?
//    private let networkService = NetworkService()
//    
//    init() {
//        bindUI()
//    }
//    
//    private func bindUI() {
//        $listings
//            .sink { [weak self] listings in
//                self?.onListingsUpdate?()
//                self?.postSearchNotification(with: listings)
//            }
//            .store(in: &cancellables)
//        
//        $selectedCategoryIndex
//            .sink { [weak self] index in
//                guard let self = self, let index = index else { return }
//                let category = CategoryViewController.categories[index].name
//                self.fetchListings(for: category)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func postSearchNotification(with listings: [Listing]) {
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: .searchPerformed, object: nil, userInfo: ["results": listings])
//        }
//    }
//    
//    func searchPlaces(query: String?, radius: Int?, near: String?) {
//        var components = URLComponents(string: "https://api.foursquare.com/v2/search/recommendations")!
//        
//        var queryItems = [
//            URLQueryItem(name: "v", value: "20231010"),
//            URLQueryItem(name: "oauth_token", value: "QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP")
//        ]
//        
//        if let query = query {
//            queryItems.append(URLQueryItem(name: "query", value: query))
//        }
//        
//        if let radius = radius {
//            queryItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
//        }
//        
//        if let near = near {
//            queryItems.append(URLQueryItem(name: "near", value: near))
//        } else {
//            queryItems.append(URLQueryItem(name: "near", value: "Tbilisi"))
//        }
//        
//        components.queryItems = queryItems
//        
//        guard let url = components.url else {
//            print("Failed to construct URL")
//            return
//        }
//        
//        print("Request URL: \(url)")
//        
//        networkService.getData(urlString: url.absoluteString) { (result: Result<PlacesResponse, Error>) in
//            switch result {
//            case .success(let decodedData):
//                let results = decodedData.response.group?.results ?? decodedData.response.results ?? []
//                DispatchQueue.main.async {
//                    let sortedResults = results.sorted { (place1, place2) -> Bool in
//                        let hasPhotos1 = (place1.photos?.groups?.first?.items.isEmpty == false)
//                        let hasPhotos2 = (place2.photos?.groups?.first?.items.isEmpty == false)
//                        return hasPhotos1 && !hasPhotos2
//                    }
//                    
//                    self.listings = sortedResults.compactMap { place in
//                        return Listing(from: place)
//                    }
//                    print("Search results fetched: \(self.listings.count)")
//                }
//            case .failure(let error):
//                print("Error occurred: \(error)")
//            }
//        }
//    }
//    
//    func configureCategoryCell(at indexPath: IndexPath, completion: @escaping (SearchCategory) -> Void) {
//        let category = CategoryViewController.categories[indexPath.row]
//        completion(category)
//    }
//    
//    func configureListingCell(at indexPath: IndexPath, completion: @escaping (Listing, Listing, [String]) -> Void) {
//        let listing = listings[indexPath.row]
//        destinationDetails(for: listing.id) { detailedListing in
//            guard let detailedListing = detailedListing else { return }
//            completion(listing, detailedListing, listing.imageUrls)
//        }
//    }
//    
//    func didSelectCategory(at indexPath: IndexPath) {
//        selectedCategoryIndex = indexPath.row
//    }
//    
//    func didSelectListing(at indexPath: IndexPath, completion: @escaping (Listing, [String]) -> Void) {
//        let listing = listings[indexPath.row]
//        destinationDetails(for: listing.id) { detailedListing in
//            guard let detailedListing = detailedListing else { return }
//            completion(detailedListing, listing.imageUrls)
//        }
//    }
//    
//    func fetchListings(for category: String?) {
//        let defaultCity = "Milan"
//        searchPlaces(query: category, radius: nil, near: defaultCity)
//    }
//    
//    func fetchLocalListings() {
//        let defaultCity = "Milan"
//        searchPlaces(query: "stores", radius: nil, near: defaultCity)
//    }
//    
//    func tierDescription(for tier: Int) -> String {
//        switch tier {
//        case 1:
//            return "Affordable"
//        case 2:
//            return "Moderate"
//        case 3:
//            return "Expensive"
//        default:
//            return "Unknown"
//        }
//    }
//    
//    func destinationDetails(for id: String, completion: @escaping (Listing?) -> Void) {
//        let urlString = "https://api.foursquare.com/v2/venues/\(id)?v=20231010&oauth_token=QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP"
//        
//        networkService.getData(urlString: urlString) { (result: Result<DetailedVenueResponse, Error>) in
//            switch result {
//            case .success(let decodedData):
//                if let venueDetail = decodedData.response.venue {
//                    let placeResult = PlaceResult(displayType: "venue", venue: venueDetail, photos: venueDetail.photos)
//                    let listing = Listing(from: placeResult)
//                    
//                    DispatchQueue.main.async {
//                        self.detailedPlace = listing
//                        completion(listing)
//                    }
//                } else {
//                    completion(nil)
//                }
//            case .failure(let error):
//                print("Failed to decode JSON: \(error)")
//                completion(nil)
//            }
//        }
//    }
//}


import Combine
import Foundation
import NetService

final class SearchViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var selectedCategoryIndex: Int? {
        didSet {
            guard let selectedIndex = selectedCategoryIndex else { return }
            let category = CategoryViewController.categories[selectedIndex].name
            fetchListings(for: category)
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var detailedPlace: Listing?
    var onListingsUpdate: (() -> Void)?
    var onCategoryIndexChanged: ((Int?) -> Void)?
    private let networkService = NetworkService()
    
    init() {
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
    }
    
    private func postSearchNotification(with listings: [Listing]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .searchPerformed, object: nil, userInfo: ["results": listings])
        }
    }
    
    func searchPlaces(query: String?, radius: Int?, near: String?) {
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
        
        if let near = near {
            queryItems.append(URLQueryItem(name: "near", value: near))
        } else {
            queryItems.append(URLQueryItem(name: "near", value: "Tbilisi"))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("Failed to construct URL")
            return
        }
        
        print("Request URL: \(url)")
        
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
                    print("Search results fetched: \(self.listings.count)")
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
        let defaultCity = "Milan"
        searchPlaces(query: category, radius: nil, near: defaultCity)
    }
    
    func fetchLocalListings() {
        let defaultCity = "Milan"
        searchPlaces(query: "stores", radius: nil, near: defaultCity)
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
