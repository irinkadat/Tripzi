//
//  ListingImageCarouselView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import SwiftUI

struct ListingImageCarouselView: View {
    var imageUrls: [String]
    @State private var currentIndex: Int = 0
    
    var body: some View {
        if !imageUrls.isEmpty {
            TabView(selection: $currentIndex) {
                ForEach(imageUrls.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: imageUrls[index])) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .tag(index)
                        case .failure:
                            Image("pic")
                                .resizable()
                                .scaledToFit()
                                .tag(index)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        } else {
            Image("pic")
                .resizable()
                .scaledToFit()
        }
    }
}
