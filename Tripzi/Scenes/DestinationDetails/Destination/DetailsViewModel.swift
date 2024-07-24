//
//  DetailsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 24.07.24.
//

//import Combine
//import Foundation
//
//final class DetailsViewModel: ObservableObject {
//    @Published var listing: Listing?
//    @Published var tips: [TipItem] = []
//    var imageUrls: [String] = []
//    
//    init(listing: Listing, imageUrls: [String]) {
//        self.listing = listing
//        self.tips = listing.tips ?? []
//        self.imageUrls = imageUrls
//    }
//    
//    func paymentDescription(_ payment: Price?) -> String {
//        guard let payment = payment else { return "No cost information available." }
//        let tierDescription = tierDescription(for: payment.tier)
//        let currency = payment.currency
//        return """
//        Tier: \(tierDescription)
//        Currency: \(currency)
//        """
//    }
//    
//    private func tierDescription(for tier: Int?) -> String {
//        switch tier {
//        case 1:
//            return "Low"
//        case 2:
//            return "Medium"
//        case 3:
//            return "High"
//        default:
//            return "Unknown"
//        }
//    }
//}


import Foundation

final class DetailsViewModel {
    let listing: Listing
    let imageUrls: [String]
    
    init(listing: Listing, imageUrls: [String]) {
        self.listing = listing
        self.imageUrls = imageUrls
    }
    
    var listingName: String {
        return listing.name
    }
    
    var listingLocation: String {
        return listing.location ?? ""
    }
    
    var listingLatitude: Double {
        return listing.lat ?? 0.0
    }
    
    var listingLongitude: Double {
        return listing.lng ?? 0.0
    }
    
    var listingWebsite: String? {
        return listing.description
    }
    
    var listingRating: String {
        return String(format: "%.2f", listing.rating)
    }
    
    var listingOpenStatus: String {
        return listing.isOpen == true ? "Closed" : "Open Now"
    }
    
    var listingCheckins: String {
        return "\(listing.stats?.checkinsCount ?? 0)"
    }
    
    var listingLocationAddress: String {
        return "\(listing.location ?? ""), \(listing.address)"
    }
    
    var listingContact: Contact? {
        return listing.contact
    }
    
    var tips: [TipItem] {
        return listing.tips ?? []
    }
    
    func paymentDescription() -> String {
        guard let payment = listing.price else { return "No cost information available." }
        let tierDescription = tierDescription(for: payment.tier)
        let currency = payment.currency
        return """
        Tier: \(tierDescription)
        Currency: \(currency)
        """
    }
    
    private func tierDescription(for tier: Int) -> String {
        switch tier {
        case 1: return "Cheap"
        case 2: return "Moderate"
        case 3: return "Expensive"
        default: return "Unknown"
        }
    }
}
