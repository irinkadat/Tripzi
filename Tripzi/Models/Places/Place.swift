//
//  Place.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct PlacesResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let group: Group?
    let results: [PlaceResult]?
    let headerFullLocation: String?
    let headerLocationGranularity: String?
}

struct Group: Codable {
    let totalResults: Int?
    let results: [PlaceResult]
}

struct PlaceResult: Codable {
    let displayType: String
    let venue: Venue?
    let photos: Photos?
}

struct Popular: Codable {
    let isOpen: Bool?
}

struct OpenTime: Codable {
    let renderedTime: String
}

struct Price: Codable {
    let tier: Int
    let message: String
    let currency: String
}

struct Photos: Codable {
    let count: Int
    let groups: [PhotoGroup]?
}

struct PhotoGroup: Codable {
    let items: [Photo]
}

struct Photo: Codable {
    let id: String
    let createdAt: Int
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
}

struct Category: Codable {
    let id: String
    let name: String
    
    init(from category: VenueCategory) {
        self.id = category.id
        self.name = category.name
    }
}

struct CatIcon: Codable {
    let prefix: String
    let suffix: String
}

struct Location: Codable {
    let address: String?
    let lat: Double?
    let lng: Double?
    let city: String?
    let state: String?
    let contextLine: String
    let country: String?
    let formattedAddress: [String]
}

struct Contact: Codable {
    let phone: String
    let formattedPhone: String
    let instagram: String
    
    init(from venueContact: VenueContact?) {
        self.phone = venueContact?.phone ?? ""
        self.formattedPhone = venueContact?.formattedPhone ?? "No phone number"
        self.instagram = venueContact?.instagram ?? "No instagram page"
    }
}



