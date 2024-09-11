//
//  DetailsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 24.07.24.
//

import Foundation

final class DetailsViewModel {
    
    // MARK: - Properties
    
    let listing: PlaceListing
    let imageUrls: [String]
    
    init(listing: PlaceListing, imageUrls: [String]) {
        self.listing = listing
        self.imageUrls = imageUrls
    }
    
    // MARK: - Computed Properties
    
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
        return listing.long ?? 0.0
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
    
    // MARK: - Methods
    
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
