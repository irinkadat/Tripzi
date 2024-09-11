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
        ZStack(alignment: .bottom) {
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
                                    .frame(width: 40, height: 40)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                CustomPageControl(
                    numberOfPages: imageUrls.count,
                    currentPage: currentIndex,
                    pageIndicatorTintColor: .white.opacity(0.6),
                    currentPageIndicatorTintColor: .white
                )
                .frame(height: 24)
                .padding(.bottom, 6)
                
            } else {
                Image("pic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
    }
}
