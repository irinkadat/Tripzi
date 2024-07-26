//
//  RegistrationView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import SwiftUI

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var fullName: String = ""
    @State private var birthDate: Date = Date()
    @State private var showError: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 20)
                
                CustomUITextField(placeholder: "Full Name", text: $fullName)
                
                DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                    .padding()
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 3)
                    )
                    .cornerRadius(18)
                    .padding()
                
                CustomUITextField(placeholder: "Email", text: $email)
                
                CustomUITextField(placeholder: "Password", text: $password, isSecure: true)
                
                CustomUITextField(placeholder: "Repeat Password", text: $repeatPassword, isSecure: true)
                
                Spacer()
                    .frame(height: 30)
                
                CustomButton(title: "Sign Up", backgroundColor: .green, textColor: .uniCo, action: {
                    if viewModel.passwordsMatch(password, repeatPassword) && viewModel.validatePassword(password: password) {
                        viewModel.register(email: email, password: password, fullName: fullName, birthDate: birthDate)
                    } else {
                        viewModel.errorMessage = "Passwords do not match or password is invalid"
                    }
                })
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .padding()
                }
            }
            .navigationTitle("Signing up")
            
        }
        .onChange(of: viewModel.registrationSuccess) {
            if viewModel.registrationSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthenticationViewModel())
}
