//
//  ResetPasswordView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import SwiftUI

struct ResetPasswordView: View {
    @Binding var email: String
    @Environment(\.presentationMode) var presentationMode
    var action: (String) -> Void
    
    var body: some View {
        VStack {
            CustomTextField(placeholder: "Enter your email", text: $email)
            
            CustomButton(title: "Send Reset Link", backgroundColor: .green, textColor: .white, action: {
                action(email)
                presentationMode.wrappedValue.dismiss()
            })
        }
        .padding()
    }
}

#Preview {
    ResetPasswordView(email: .constant(""), action: { _ in })
        .environmentObject(AuthenticationViewModel())
}
