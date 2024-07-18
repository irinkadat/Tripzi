//
//  HomeViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import Foundation

class HomeViewModel {
    var listings: [Listing] = []
    
    init() {
        fetchListings()
    }
    
    func fetchListings() {
        for i in 1...10 {
            listings.append(Listing(
                imageName: "desert",
                location: "Location \(i), Wisconsin",
                designer: "Frank Lloyd Wright",
                dateRange: "Jun \(i) – \(i + 7)",
                price: "$\(569 + i * 20) night",
                rating: 4.91 - Double(i) * 0.02
            ))
        }
    }
}



