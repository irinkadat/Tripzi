//
//  ListingView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 08.07.24.
//

import Foundation
import SwiftUI

struct Listing: Identifiable {
    var id = UUID()
    var imageName: String
    var location: String
    var designer: String
    var dateRange: String
    var price: String
    var rating: Double
}

struct ListingView: View {
    var listing: Listing
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        TabView {
                            ForEach(0...3, id: \.self) { image in
                                Image(listing.imageName)
                                    .resizable()
                                    .scaledToFill()
                                
                            }
                        }
                        .frame(height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .tabViewStyle(.page)
                        
                        
                        
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
            .background(Color.white)
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ListingView(listing: Listing(
        imageName: "desert",
        location: "Two Rivers, Wisconsin",
        designer: "Frank Lloyd Wright",
        dateRange: "Jun 6 – 13",
        price: "$569 night",
        rating: 4.91
    ))
}
