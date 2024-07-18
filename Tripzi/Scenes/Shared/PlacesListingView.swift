//
//  PlacesListingView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 08.07.24.
//

import Foundation
import SwiftUI

struct PlacesListingView: View {
    var listing: Listing
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        ListingImageCarouselView(imageName: "desert")
                            .frame(height: 320)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .onTapGesture {
                                onTap() 
                            }
                
                        Image(systemName: "heart")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 21))
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(listing.location)
                            .font(.headline)
                            .padding(.top, 5)
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow.opacity(0.7))
                        Text(String(format: "%.2f", listing.rating))
                            .font(.headline)
                            .padding(.trailing, 8)
                    }
                    
                    Group {
                        Text("Designed by \(listing.designer)")
                        
                        Text(listing.dateRange)
                    }
                    .secondaryTextStyle()
                    
                    HStack {
                        Text(listing.price)
                            .font(.headline)
                    }
                    .padding(.top, 4)
                }
            }
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PlacesListingView(
        listing: Listing(
            imageName: "desert",
            location: "Two Rivers, Wisconsin",
            designer: "Frank Lloyd Wright",
            dateRange: "Jun 6 – 13",
            price: "$569 night",
            rating: 4.91
        ),
        onTap: { }
    )
}
