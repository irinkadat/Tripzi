//
//  SecondaryTextStyle.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import SwiftUI

struct SecondaryTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

extension View {
    func secondaryTextStyle() -> some View {
        self.modifier(SecondaryTextStyle())
    }
}
