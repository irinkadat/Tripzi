//
//  CustomTextField.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
            
            VStack {
                ZStack(alignment: .leading) {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .padding()
                            .frame(height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 3)
                            )
                            .cornerRadius(18)
                            .autocapitalization(.none)
                            .textContentType(.oneTimeCode)
                            .disableAutocorrection(true)
                    } else {
                        TextField(placeholder, text: $text)
                            .padding()
                            .frame(height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 3)
                            )
                            .cornerRadius(18)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    CustomTextField(placeholder: "Enter your email", text: .constant(""), isSecure: false)
}
