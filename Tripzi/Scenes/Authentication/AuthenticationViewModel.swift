//
//  AuthenticationViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 27.06.24.
//

import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    @Published var currentAuthView: AuthView = .login
    @Published var registrationSuccess = false
    @Published var shouldDismiss = false
    @Published var successMessage: String?
    @Published var password: String = ""
    @Published var isPasswordValid: Bool = false
    
    private var authenticationManager = AuthenticationManager()
    private var cancellables = Set<AnyCancellable>()
    
    enum AuthView {
        case login, register, resetPassword
    }
    
    init() {
        bindAuthenticationManager()
        
        $password
            .map { password in
                self.validatePassword(password: password)
            }
            .assign(to: &$isPasswordValid)
         
    }
    
    private func bindAuthenticationManager() {
        authenticationManager.$isSignedIn
            .receive(on: RunLoop.main)
            .assign(to: \.isSignedIn, on: self)
            .store(in: &cancellables)
        
        authenticationManager.$errorMessage
            .receive(on: RunLoop.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    func login(email: String, password: String) {
        authenticationManager.signInWithEmail(email: email, password: password)
    }
    
    func register(email: String, password: String, fullName: String, birthDate: Date) {
        authenticationManager.registerUser(withEmail: email, password: password, fullName: fullName, birthDate: birthDate)
    }
    
    func signInWithGoogle() {
        authenticationManager.signInWithGoogle()
    }
    
    func signInWithFacebook() {
        authenticationManager.signInWithFacebook()
    }
    
    func signOut() {
        authenticationManager.signOut()
    }
    
    func showLogin() {
        currentAuthView = .login
    }
    
    func showRegister() {
        currentAuthView = .register
    }
    
    func showResetPassword() {
        currentAuthView = .resetPassword
    }
    
    func resetPassword(email: String) {
        authenticationManager.resetPassword(email: email) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self?.successMessage = "Password reset email sent successfully. Check your email."
                } else {
                    self?.errorMessage = errorMessage ?? "An unknown error occurred."
                }
            }
        }
    }
    
//    func passwordsMatch(_ password: String, _ repeatPassword: String) -> Bool {
//        if password != repeatPassword {
//            errorMessage = "Passwords do not match."
//            return false
//        }
//        return true
//    }
    
    func passwordsMatch(_ password: String, _ repeatPassword: String) -> Bool {
        // Added debug print statement to log the password comparison
        print("Comparing passwords: \(password) == \(repeatPassword)")
        if password != repeatPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        return true
    }

    
//    func validatePassword(password: String) -> Bool {
//        let hasUpperCase = password.range(of: "[A-Z]", options: .regularExpression) != nil
//        let hasDigits = password.range(of: "\\d", options: .regularExpression) != nil
//        return hasUpperCase && hasDigits
//    }
    
    func validatePassword(password: String) -> Bool {
        // Added validation for lower case letters and password length
        let hasUpperCase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowerCase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigits = password.range(of: "\\d", options: .regularExpression) != nil
        let isLongEnough = password.count >= 6
        let isValid = hasUpperCase && hasLowerCase && hasDigits && isLongEnough
        // Added debug print statement to log the validation result
        print("Validating password: \(password) -> \(isValid)")
        return isValid
    }

}
