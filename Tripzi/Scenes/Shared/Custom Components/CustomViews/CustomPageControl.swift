//
//  CustomPageControl.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 06.09.24.
//

import SwiftUI

struct CustomPageControl: View {
    var numberOfPages: Int
    var currentPage: Int
    var pageIndicatorTintColor: Color
    var currentPageIndicatorTintColor: Color
    private let maxDots = 5
    
    var body: some View {
        let startPage = max(0, currentPage - (maxDots / 2))
        let endPage = min(numberOfPages, startPage + maxDots)
        
        HStack {
            Spacer()
            
            HStack(spacing: 6) {
                ForEach(startPage..<endPage, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor)
                        .frame(width: 7, height: 7)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.spring(), value: currentPage)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
