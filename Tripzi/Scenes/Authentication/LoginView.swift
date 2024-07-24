//
//  LoginView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingRegister = false
    @State private var showingResetPassword = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 50)
                
                CustomUITextField(placeholder: "Enter your email", text: $email, isSecure: false)
                
                CustomUITextField(placeholder: "Enter your password", text: $password, isSecure: true)
                
                Spacer()
                    .frame(height: 20)
                
                CustomButton(
                    title: "Log in",
                    backgroundColor: .green,
                    textColor: Color.white,
                    action: {
                        viewModel.login(email: email, password: password)
                    }
                )
                
                CustomButton(
                    title: "Forgot password?",
                    backgroundColor: Color.clear,
                    textColor: Color.black.opacity(0.7),
                    action: {
                        showingResetPassword = true
                    }
                )
                .sheet(isPresented: $showingResetPassword) {
                    ResetPasswordView(email: $email, action: { resetEmail in
                        viewModel.resetPassword(email: resetEmail)
                    })
                }
                
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal)
                
                Spacer()
                    .frame(height: 30)
                
                CustomButton(
                    title: "Sign Up With Email",
                    backgroundColor: .customBlack,
                    textColor: Color.white,
                    action: {
                        showingRegister.toggle()
                    }, icon: "envelope"
                )
                .sheet(isPresented: $showingRegister) {
                    RegistrationView().environmentObject(viewModel)
                }
                
                Spacer()
                    .frame(height: 14)
                
                CustomButton(
                    title: "Sign in with Google",
                    backgroundColor: .customBlack,
                    textColor: Color.white,
                    action: {
                        viewModel.signInWithGoogle()
                    }, icon: "globe"
                )
                
                Spacer()
                    .frame(height: 14)
                
                CustomButton(
                    title: "Sign in with Facebook",
                    backgroundColor: .customBlack,
                    textColor: Color.white,
                    action: {
                        viewModel.signInWithFacebook()
                    }, icon: "f.circle"
                )
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .padding()
                }
                
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .padding()
                }
            }
            .navigationTitle("Log in or Sign up")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onChange(of: viewModel.isSignedIn) {
            if viewModel.isSignedIn {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
