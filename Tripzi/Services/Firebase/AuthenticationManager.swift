//
//  AuthenticationManager.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FirebaseCore
import FirebaseFirestore

class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.isSignedIn = user != nil
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            self?.isSignedIn = true
        }
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String, birthDate: Date) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            guard let userId = authResult?.user.uid else {
                self?.errorMessage = "User ID not found"
                return
            }
            self?.saveUserData(fullName: fullName, birthDate: birthDate, userId: userId)
        }
    }
    
    private func saveUserData(fullName: String, birthDate: Date, userId: String) {
        let db = Firestore.firestore()
        let userData = ["fullName": fullName, "birthDate": Timestamp(date: birthDate), "userId": userId] as [String : Any]
        db.collection("users").document(userId).setData(userData) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to save user data: \(error.localizedDescription)"
            } else {
                self?.isSignedIn = true
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        _ = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("There is no root view controller!")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString
            else {
                self?.errorMessage = "Failed to get user credentials."
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                self?.isSignedIn = true
            }
        }
    }
    
    func signInWithFacebook() {
        let loginManager = LoginManager()
        
        let permissions: Set<Permission> = Set([Permission(stringLiteral: "public_profile"), Permission(stringLiteral: "email")])
        
        let configuration = LoginConfiguration(permissions: permissions)
        
        loginManager.logIn(viewController: getRootViewController(), configuration: configuration) { [weak self] result in
            switch result {
            case .success(_, _, let token):
                guard let tokenString = token?.tokenString else {
                    self?.errorMessage = "Failed to retrieve valid token"
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    self?.isSignedIn = true
                }
            case .cancelled:
                self?.errorMessage = "User cancelled login."
            default:
                self?.errorMessage = "An unknown error occurred"
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
    
    private func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        return window.rootViewController!
    }
}

