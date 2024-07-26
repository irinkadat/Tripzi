//
//  Venue.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct Venue: Codable {
    let id: String
    let name: String
    let location: Location
    let categories: [VenueCategory]
    let rating: Double?
    let url: String?
    let contact: VenueContact
    let stats: Stats?
    let price: Price?
    let popular: Popular?
    let tips: Tips?
    let photos: Photos?
}

struct DetailedVenueResponse: Codable {
    let response: DetailedVenue
}

struct DetailedVenue: Codable {
    let venue: Venue?
}

struct VenueCategory: Codable {
    let id: String
    let name: String
}

struct VenueContact: Codable {
    let phone: String?
    let formattedPhone: String?
    let instagram: String?
}

struct Stats: Codable {
    let tipCount: Int
    let checkinsCount: Int
}
