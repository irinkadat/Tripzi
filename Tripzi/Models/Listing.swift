//
//  Listing.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import Foundation

struct Listing: Identifiable {
    var id = UUID()
    var imageName: String
    var location: String
    var designer: String
    var dateRange: String
    var price: String
    var rating: Double
}
