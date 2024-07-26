//
//  Venue.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct Venue: Decodable {
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

struct DetailedVenueResponse: Decodable {
    let response: DetailedVenue
}

struct DetailedVenue: Decodable {
    let venue: Venue?
}

struct VenueCategory: Decodable {
    let id: String
    let name: String
}

struct VenueContact: Decodable {
    let phone: String?
    let formattedPhone: String?
    let instagram: String?
}

struct Stats: Decodable {
    let tipCount: Int
    let checkinsCount: Int
}
