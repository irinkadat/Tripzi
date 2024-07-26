//
//  ProfileViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Combine
import NetService

final class ProfileViewModel: NSObject {
    @Published var userName: String?
    @Published var userEmail: String?
    @Published var userBirthDate: Date?
    @Published var userImage: UIImage?
    @Published var authButtonTitle: String?
    private let networkService = NetworkService()
    
    
    private var isUserInfoFetched = false
    private var subscriptions = Set<AnyCancellable>()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private let firestoreService = FirebaseFirestoreService.shared
    
    override init() {
        super.init()
        fetchUserInfoIfNeeded(forceFetch: true)
        setupAuthButtonTitle()
        setupNotificationObservers()
        setupAuthStateListener()
    }
    
    // MARK: - Fetch User Info

    func fetchUserInfoIfNeeded(forceFetch: Bool = false) {
        if !isUserInfoFetched || forceFetch {
            fetchUserInfo()
        }
    }
    
    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else {
            updateStateForLoggedOutUser()
            return
        }
        
        userName = user.displayName ?? "No Name"
        userEmail = user.email ?? "No Email"
        if let photoURL = user.photoURL {
            fetchProfileImage(from: photoURL)
        }
        
        firestoreService.fetchUserInfo(userId: user.uid) { [weak self] result in
            switch result {
            case .success(let data):
                self?.updateStateWithFetchedData(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.isUserInfoFetched = true
        }
    }
    
    // MARK: - Update Profile Image

    private func fetchProfileImage(from url: URL) {
        networkService.fetchData(urlString: url.absoluteString) { [weak self] result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.userImage = image
                    }
                }
            case .failure(let error):
                print("Error fetching profile image: \(error)")
            }
        }
    }
    
    private func updateStateForLoggedOutUser() {
        userName = "No User Logged In"
        userEmail = "No Email"
        userImage = UIImage(named: "nouser")
        authButtonTitle = "Log in"
    }
    
    private func updateStateWithFetchedData(_ data: [String: Any]) {
        userName = data["fullName"] as? String ?? userName
        if let birthdateTimestamp = data["birthDate"] as? Timestamp {
            userBirthDate = birthdateTimestamp.dateValue()
        }
    }
    
    func updateProfileImage(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        firestoreService.uploadImageToServer(image) { [weak self] result in
            switch result {
            case .success(let url):
                self?.firestoreService.updateUserProfile(photoURL: url) { result in
                    switch result {
                    case .success:
                        NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                        completion(true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupAuthButtonTitle() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.authButtonTitle = user != nil ? "Log out" : "Log in"
            self?.fetchUserInfoIfNeeded(forceFetch: true)
        }
    }
    
    func handleAuthButtonTap(completion: @escaping () -> Void) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                isUserInfoFetched = false
                updateStateForLoggedOutUser()
                fetchUserInfoIfNeeded(forceFetch: true)
                completion()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        } else {
            completion()
        }
    }
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthStateChange), name: .AuthStateDidChange, object: nil)
    }
    
    @objc private func handleAuthStateChange() {
        fetchUserInfoIfNeeded(forceFetch: true)
    }
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.fetchUserInfoIfNeeded(forceFetch: true)
        }
    }
    
    func cleanup() {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Handle Picked Image

    func handlePickedImage(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let editedImage = info[.editedImage] as? UIImage {
            updateProfileImage(editedImage) { success in
                if success {
                    NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                }
            }
            return editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            updateProfileImage(originalImage) { success in
                if success {
                    NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                }
            }
            return originalImage
        } else {
            return nil
        }
    }
    
    // MARK: - Bind UI

    func bindProfileUI(nameLabel: UILabel, imageView: UIImageView, authButton: UIButton) {
        $userName
            .receive(on: RunLoop.main)
            .sink { userName in
                nameLabel.text = userName
            }
            .store(in: &subscriptions)
        
        $userImage
            .receive(on: RunLoop.main)
            .sink { userImage in
                imageView.image = userImage
            }
            .store(in: &subscriptions)
        
        $authButtonTitle
            .receive(on: RunLoop.main)
            .sink { title in
                authButton.setTitle(title, for: .normal)
            }
            .store(in: &subscriptions)
    }
    
    func bindPersonalInfoUI(nameLabel: UILabel, emailLabel: UILabel, birthdateLabel: UILabel) {
        $userName
            .receive(on: RunLoop.main)
            .sink { userName in
                nameLabel.text = userName
            }
            .store(in: &subscriptions)
        
        $userEmail
            .receive(on: RunLoop.main)
            .sink { userEmail in
                emailLabel.text = userEmail
            }
            .store(in: &subscriptions)
        
        $userBirthDate
            .receive(on: RunLoop.main)
            .sink { userBirthDate in
                if let date = userBirthDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    birthdateLabel.text = dateFormatter.string(from: date)
                } else {
                    birthdateLabel.text = "No Birthdate"
                }
            }
            .store(in: &subscriptions)
    }
}
