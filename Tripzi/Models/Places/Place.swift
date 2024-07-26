//
//  Place.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct PlacesResponse: Decodable {
    let response: Response
}

struct Response: Decodable {
    let group: Group?
    let results: [PlaceResult]?
    let headerFullLocation: String?
    let headerLocationGranularity: String?
}

struct Group: Decodable {
    let totalResults: Int?
    let results: [PlaceResult]
}

struct PlaceResult: Decodable {
    let displayType: String
    let venue: Venue?
    let photos: Photos?
}

struct Popular: Decodable {
    let isOpen: Bool?
}

struct OpenTime: Decodable {
    let renderedTime: String
}

struct Price: Decodable {
    let tier: Int
    let message: String
    let currency: String
}

struct Photos: Decodable {
    let count: Int
    let groups: [PhotoGroup]?
}

struct PhotoGroup: Decodable {
    let items: [Photo]
}

struct Photo: Decodable {
    let id: String
    let createdAt: Int
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
}

struct Category: Decodable {
    let id: String
    let name: String
    
    init(from category: VenueCategory) {
        self.id = category.id
        self.name = category.name
    }
}

struct CatIcon: Decodable {
    let prefix: String
    let suffix: String
}

struct Location: Decodable {
    let address: String?
    let lat: Double?
    let lng: Double?
    let city: String?
    let state: String?
    let contextLine: String
    let country: String?
    let formattedAddress: [String]
}


struct Contact: Decodable {
    let phone: String
    let formattedPhone: String
    let instagram: String
    
    init(from venueContact: VenueContact?) {
        self.phone = venueContact?.phone ?? ""
        self.formattedPhone = venueContact?.formattedPhone ?? "No phone number"
        self.instagram = venueContact?.instagram ?? "No instagram page"
    }
}



