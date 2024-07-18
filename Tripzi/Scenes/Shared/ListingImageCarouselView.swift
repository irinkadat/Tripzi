//
//  ListingImageCarouselView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import SwiftUI

struct ListingImageCarouselView: View {
    var imageName: String

    var body: some View {
        TabView {
            ForEach(0...3, id: \.self) { image in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview() {
    ListingImageCarouselView(
        imageName: "desert")
    
}
