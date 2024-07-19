//
//  SearchViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    private var cancellables: Set<AnyCancellable> = []
    @Published var detailedPlace: Listing?
    
    func fetchDefaultListings() {
        guard let url = Bundle.main.url(forResource: "Places", withExtension: "json") else {
            print("Failed to locate JSON file.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(PlacesResponse.self, from: data)
            let results = decodedData.response.group?.results ?? []
            
            let sortedResults = results.sorted { (place1, place2) -> Bool in
                let hasPhotos1 = (place1.photos?.groups?.first?.items.isEmpty == false)
                let hasPhotos2 = (place2.photos?.groups?.first?.items.isEmpty == false)
                return hasPhotos1 && !hasPhotos2
            }
            
            self.listings = sortedResults.compactMap { place in
                return Listing(from: place)
            }
            print("Default listings fetched: \(self.listings.count)")
        } catch {
            print("Failed to decode JSON: \(error)")
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
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No readable data")")
            
            do {
                let decodedData = try JSONDecoder().decode(PlacesResponse.self, from: data)
                let results = decodedData.response.group?.results ?? decodedData.response.results ?? []
                DispatchQueue.main.async {
                    self.listings = results.compactMap { result in
                        guard result.displayType == "venue", let venue = result.venue else {
                            print("Skipping result with displayType: \(result.displayType)")
                            return nil
                        }
                        return Listing(from: result)
                    }
                    print("Search results fetched: \(self.listings.count)")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchListings(for category: String?) {
        let defaultCity = "Milan"
        searchPlaces(query: category, radius: nil, near: defaultCity)
    }
    
    func destinationDetails(for id: String, completion: @escaping (Listing?) -> Void) {
        let urlString = "https://api.foursquare.com/v2/venues/\(id)?v=20231010&oauth_token=QEJ4AQPTMMNB413HGNZ5YDMJSHTOHZHMLZCAQCCLXIX41OMP"
        
        guard let url = URL(string: urlString) else {
            print("Failed to construct URL")
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(DetailedVenueResponse.self, from: data)
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
            } catch {
                print("Failed to decode JSON \(error)")
                completion(nil)
            }
        }.resume()
    }
}
