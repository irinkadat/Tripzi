//
//  FirebaseFirestoreService.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 23.07.24.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit
import FirebaseAuth

final class FirebaseFirestoreService {
    
    static let shared = FirebaseFirestoreService()
    
    private init() {}
    
    // MARK: - Fetch User Info
    
    func fetchUserInfo(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                completion(.success(data))
            } else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Firestore document for the user found"])
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Upload Image

    func uploadImageToServer(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get JPEG representation of UIImage"])
            completion(.failure(error))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let url = url {
                    completion(.success(url))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Update User Profile
    
    func updateUserProfile(photoURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.photoURL = photoURL
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
            completion(.failure(error))
        }
    }
}
