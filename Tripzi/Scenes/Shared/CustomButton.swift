//
//  CustomButton.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var action: () -> Void
    var icon: String?
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(textColor)
                }
                Text(title)
                    .foregroundColor(textColor)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(18)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomButton(title: "Login", backgroundColor: .green, textColor: .white, action: {})
}
