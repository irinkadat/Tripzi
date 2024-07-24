//
//  PlacesListingView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 08.07.24.
//

import Foundation
import SwiftUI

struct PlacesListingView: View {
    @ObservedObject var viewModel: PlacesListingViewModel
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        ListingImageCarouselView(imageUrls: viewModel.listing.imageUrls)
                            .frame(height: 320)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .onTapGesture {
                                onTap()
                            }

                        Button(action: {
                            viewModel.isFavorited.toggle()
                            if viewModel.isFavorited {
                                viewModel.saveToFavorites()
                            } else {
                                viewModel.removeFromFavorites()
                            }
                        }) {
                            Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                                .padding()
                                .foregroundColor(.white)
                                .font(.system(size: 21))
                        }
                    }
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.listing.name)
                            .font(.headline)
                            .padding(.top, 5)
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow.opacity(0.7))
                        Text(String(format: "%.2f", (viewModel.listing.rating)))
                            .font(.headline)
                            .padding(.trailing, 8)
                    }

                    VStack(alignment: .leading) {
                        Text("Address \(viewModel.listing.address)")
                        Text(viewModel.listing.contextLine)
                    }
                    .secondaryTextStyle()

                    HStack {
                        Text(viewModel.listing.categorieName)
                            .font(.headline)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.checkIfFavorited()
        }
    }
}
