//
//  ProfileViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userName: String? {
        didSet {
            self.updateUI?()
        }
    }
    var userEmail: String? {
        didSet {
            self.updateUI?()
        }
    }
    var userBirthDate: Date? {
        didSet {
            self.updateUI?()
        }
    }
    var userImage: UIImage? {
        didSet {
            self.updateUI?()
        }
    }
    var updateUI: (() -> Void)?
    
    override init() {
        super.init()
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else {
            userName = "No User Logged In"
            userEmail = "No Email"
            userImage = UIImage(systemName: "person.circle")!
            updateUI?()
            return
        }
        
        userName = user.displayName ?? "No Name"
        userEmail = user.email ?? "No Email"
        if let photoURL = user.photoURL {
            fetchProfileImage(from: photoURL)
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                let data = document.data()
                self?.userName = data?["fullName"] as? String ?? self?.userName
                if let birthdateTimestamp = data?["birthDate"] as? Timestamp {
                    self?.userBirthDate = birthdateTimestamp.dateValue()
                }
            } else {
                print("No Firestore document for the user found")
            }
            self?.updateUI?()
        }
    }
    
    private func fetchProfileImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.userImage = image
                }
            }
        }
        task.resume()
    }
    
    func updateProfileImage(_ image: UIImage) {
        self.userImage = image
        uploadImageToServer(image) { [weak self] url in
            guard let url = url else { return }
            self?.updateUserProfile(with: url)
        }
    }

    private func uploadImageToServer(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Failed to get JPEG representation of UIImage")
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                print("Image successfully uploaded with URL: \(url!.absoluteString)")
                completion(url)
            }
        }
    }
    
    private func updateUserProfile(with photoURL: URL) {
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.photoURL = photoURL
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating user profile: \(error.localizedDescription)")
                } else {
                    print("User profile updated successfully")
                }
            }
        }
    }
    
    func presentImagePicker(from viewController: UIViewController) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        viewController.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            updateProfileImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            updateProfileImage(originalImage)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
