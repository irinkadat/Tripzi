//
//  Listing.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import Foundation

struct Listing: Identifiable, Codable {
    let id: String
    let categories: [Category]
    let categorieName: String
    let name: String
    let price: Price?
    let location: String?
    let address: String
    let rating: Double
    let crossStreet: String?
    let header: String?
    let contextLine: String
    let imageUrls: [String]
    let description: String?
    let contact: Contact?
    let stats: Stats?
    var isFavorited: Bool = false
    let photos: [PhotoGroup]?
    let tips: [TipGroup]?
    let summary: String?
    let isOpen: Bool?
    let timeframes: [Timeframe]?

    init?(from result: PlaceResult) {
        guard let venue = result.venue else {
            return nil
        }
        
        self.id = venue.id
        self.categories = venue.categories.map { Category(from: $0) }
        self.name = venue.name
        self.price = venue.price
        self.location = venue.location.city
        self.categorieName = venue.categories[0].name
        self.address = venue.location.address ?? ""
        self.header = venue.header
        self.crossStreet = venue.location.crossStreet
        self.rating = venue.rating ?? 0.0
        self.contextLine = venue.location.contextLine
        self.imageUrls = result.photos?.groups.flatMap { $0.items.map { "\($0.prefix)\($0.width)x\($0.height)\($0.suffix)" } } ?? []
        self.description = venue.url
        self.contact = Contact(from: venue.contact)
        self.stats = venue.stats
        self.isFavorited = false
        self.photos = result.photos?.groups
        self.tips = nil
        self.summary = venue.summary
        self.isOpen = venue.popular?.isOpen
        self.timeframes = venue.popular?.timeframes
    }
}
