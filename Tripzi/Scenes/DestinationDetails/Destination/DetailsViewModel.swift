//
//  DetailsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 24.07.24.
//

import Combine
import Foundation

final class DetailsViewModel: ObservableObject {
    @Published var listing: Listing?
    @Published var tips: [TipItem] = []
    var imageUrls: [String] = []
    
    init(listing: Listing, imageUrls: [String]) {
        self.listing = listing
        self.tips = listing.tips ?? []
        self.imageUrls = imageUrls
    }
    
    func paymentDescription(_ payment: Price?) -> String {
        guard let payment = payment else { return "No cost information available." }
        let tierDescription = tierDescription(for: payment.tier)
        let currency = payment.currency
        return """
        Tier: \(tierDescription)
        Currency: \(currency)
        """
    }
    
    private func tierDescription(for tier: Int?) -> String {
        switch tier {
        case 1:
            return "Low"
        case 2:
            return "Medium"
        case 3:
            return "High"
        default:
            return "Unknown"
        }
    }
}
