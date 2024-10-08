//
//  Listing.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct PlaceListing: Identifiable, Codable {
    let id: String
    let categories: [Category]
    let categorieName: String
    let name: String
    let price: Price?
    let location: String?
    let address: String
    let rating: Double
    let contextLine: String
    let lat: Double?
    let long: Double?
    var imageUrls: [String]
    let description: String?
    let contact: Contact?
    let stats: Stats?
    var isFavorited: Bool = false
    let tips: [TipItem]?
    let isOpen: Bool?
    var timestamp: Timestamp?
    
    init?(from result: PlaceResult) {
        guard let venue = result.venue else {
            return nil
        }
        
        self.id = venue.id
        self.categories = venue.categories.map { Category(from: $0) }
        self.name = venue.name
        self.price = venue.price
        self.location = venue.location.city
        
        if let firstCategory = venue.categories.first?.name {
            self.categorieName = firstCategory
        } else {
            self.categorieName = "hotel"
        }
        
        self.address = venue.location.address ?? ""
        self.rating = venue.rating ?? 0.0
        self.contextLine = venue.location.contextLine
        self.imageUrls = result.photos?.groups?.flatMap { $0.items.map { "\($0.prefix)\($0.width)x\($0.height)\($0.suffix)" } } ?? []
        self.description = venue.url
        self.contact = Contact(from: venue.contact)
        self.stats = venue.stats
        self.isFavorited = false
        self.tips = venue.tips?.groups?.flatMap { group in
            group.items ?? []
        }
        self.lat = venue.location.lat
        self.long = venue.location.lng
        self.isOpen = venue.popular?.isOpen
        self.timestamp = Timestamp(date: Date())
    }
}


