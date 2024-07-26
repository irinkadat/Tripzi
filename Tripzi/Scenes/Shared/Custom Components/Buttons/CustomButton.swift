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
            Spacer()

            HStack {
                if let iconName = icon {
                    Image(iconName)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(textColor)
                        .padding(.leading, 6)
                }
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(textColor)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(18)
            
            Spacer()
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    CustomButton(title: "Login", backgroundColor: .green, textColor: .white, action: {})
}
