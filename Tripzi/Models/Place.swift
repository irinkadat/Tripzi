//
//  Place.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct Category: Codable {
    let id: String
    let name: String
    let shortName: String
    let pluralName: String
    let icon: CatIcon

    init(from category: VenueCategory) {
        self.id = category.id
        self.name = category.name
        self.shortName = category.shortName
        self.pluralName = category.pluralName
        self.icon = CatIcon(prefix: category.icon.prefix, suffix: category.icon.suffix)
    }
}

struct CatIcon: Codable {
    let prefix: String
    let suffix: String
}

struct PlacesResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let group: Group?
    let results: [PlaceResult]?
    //
    let context: Context?
    let headerFullLocation: String?
    let headerLocationGranularity: String?
}


struct AnnotatedGroupName: Codable {
    let text: String?
    let entities: [String]?
}

struct ActiveFilters: Codable {
    let refinements: [String]?
    let query: String?
}


struct Context: Codable {
    let searchLocationNearYou: Bool?
    let searchLocationMapBounds: Bool?
    let searchLocationType: String?
    let currentLocation: CurrentLocation?
    let relatedNeighborhoods: [String]?
    let geoBounds: GeoBounds?
    let currency: String?
}
struct Group: Codable {
    let annotatedGroupName: AnnotatedGroupName?
    let activeFilters: ActiveFilters?
    let totalResults: Int?
    let results: [PlaceResult]
}

struct Feature: Codable {
//    let cc: String?
    let name: String?
    let displayName: String?
    let matchedName: String?
    let highlightedName: String?
    let id: String?
    let longId: String?
    let geometry: Geometry?
}

struct Tips: Codable {
    let count: Int?
    let groups: [TipGroup]?
}

struct TipGroup: Codable {
    let type: String?
    let name: String?
    let count: Int?
    let items: [TipItem]?
}

struct TipItem: Codable, Identifiable {
    let id: String
    let createdAt: Int?
    let text: String
    let type: String?
    let agreeCount: Int?
    let disagreeCount: Int?
    let user: TipUser?
}

struct TipUser: Codable {
    let id: String
    let firstName: String?
    let lastName: String?
    let countryCode: String?
    let photo: UserPhoto?
}


struct Geometry: Codable {
    let center: Center?
}

struct Center: Codable {
    let lat: Double?
    let lng: Double?
}

struct NE: Codable {
    let lat: Double?
    let lng: Double?
}

struct CurrentLocation: Codable {
    let what: String?
    let feature: Feature?
    let parents: [String]?
}

struct GeoBounds: Codable {
    let geoId: String?
}

struct PlaceResult: Codable {
    let displayType: String
    let venue: Venue?
    let photos: Photos?
}

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
    let header: String?
    let summary: String?
    let tips: Tips?
    let popular: Popular?
}

struct Popular: Codable {
    let isOpen: Bool?
    let timeframes: [Timeframe]
}
struct Timeframe: Codable {
    let days: String
    let includesToday: Bool
    let open: [OpenTime]
    let segments: [String]
}

struct OpenTime: Codable {
    let renderedTime: String
}

struct Price: Codable {
    let tier: Int
    let message: String
    let currency: String
}

struct VenueCategory: Codable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: VenueIcon
}

struct VenueIcon: Codable {
    let prefix: String
    let suffix: String
}

struct Photos: Codable {
    let count: Int
    let groups: [PhotoGroup]
}

struct PhotoGroup: Codable {
    let type: String
    let name: String
    let count: Int
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

struct Location: Codable {
    let address: String?
    let crossStreet: String?
    let lat: Double?
    let lng: Double?
    let city: String?
    let state: String?
    let contextLine: String
    let country: String?
    let formattedAddress: [String]
}

struct VenueContact: Codable {
    let phone: String?
    let formattedPhone: String?
    let instagram: String?
}

struct Contact: Codable {
    let phone: String
    let formattedPhone: String
    let instagram: String

    init(from venueContact: VenueContact) {
        self.phone = venueContact.phone ?? ""
        self.formattedPhone = venueContact.formattedPhone ?? "No phone number"
        self.instagram = venueContact.instagram ?? "No instagram page"
    }
}

struct Stats: Codable {
    let tipCount: Int
    let usersCount: Int
    let checkinsCount: Int
}

struct LikeGroup: Codable {
    let type: String?
    let count: Int?
    let items: [String]?
}

struct UserPhoto: Codable {
    let prefix: String?
    let suffix: String?
}

struct DetailedVenueResponse: Codable {
    let response: DetailedVenue
}

struct DetailedVenue: Codable {
    let venue: Venue?
}
