//
//  FavoritesViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//
//class FavoritesViewModel: ObservableObject {
//    @Published var favorites: [Listing] = []
//    private var db = Firestore.firestore()
//    private var listener: ListenerRegistration?
//    private var userId: String? {
//        return Auth.auth().currentUser?.uid
//    }
//    
//    init() {
//        listenToFavorites()
//    }
//    
//    func fetchFavorites() {
//        guard let userId = userId else { return }
//        db.collection("users").document(userId).collection("favorites").getDocuments { [weak self] snapshot, error in
//            guard let documents = snapshot?.documents else {
//                print("No documents")
//                return
//            }
//            
//            self?.favorites = documents.compactMap { document in
//                try? document.data(as: Listing.self)
//            }
//        }
//    }
//    
//    func listenToFavorites() {
//        guard let userId = userId else { return }
//        listener = db.collection("users").document(userId).collection("favorites").addSnapshotListener { [weak self] snapshot, error in
//            guard let documents = snapshot?.documents else {
//                print("No documents")
//                return
//            }
//            
//            self?.favorites = documents.compactMap { document in
//                try? document.data(as: Listing.self)
//            }
//        }
//    }
//    
//    deinit {
//        listener?.remove()
//    }
//}

//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//import Combine
//
//final class FavoritesViewModel: ObservableObject {
//    @Published var favorites: [Listing] = []
//    private var db = Firestore.firestore()
//    private var listener: ListenerRegistration?
//    private var cancellables = Set<AnyCancellable>()
//    private var userId: String? {
//        return Auth.auth().currentUser?.uid
//    }
//    
//    init() {
//        listenToFavorites()
//        setupNotificationObservers()
//    }
//    
//    private func setupNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthStateChange), name: .AuthStateDidChange, object: nil)
//    }
//
//    @objc private func handleAuthStateChange() {
//        stopListeningToFavorites()
//        listenToFavorites()
//    }
//
//    func fetchFavorites() {
//        guard let userId = userId else {
//            favorites = []
//            return
//        }
//        db.collection("users").document(userId).collection("favorites").getDocuments { [weak self] snapshot, error in
//            guard let documents = snapshot?.documents else {
//                print("No documents")
//                return
//            }
//            
//            self?.favorites = documents.compactMap { document in
//                try? document.data(as: Listing.self)
//            }
//        }
//    }
//    
//    func listenToFavorites() {
//        guard let userId = userId else {
//            favorites = []
//            return
//        }
//        listener = db.collection("users").document(userId).collection("favorites").addSnapshotListener { [weak self] snapshot, error in
//            guard let documents = snapshot?.documents else {
//                print("No documents")
//                return
//            }
//            
//            self?.favorites = documents.compactMap { document in
//                try? document.data(as: Listing.self)
//            }
//        }
//    }
//    
//    private func stopListeningToFavorites() {
//        listener?.remove()
//        listener = nil
//    }
//    
//    deinit {
//        stopListeningToFavorites()
//        NotificationCenter.default.removeObserver(self)
//    }
//}


import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Listing] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    init() {
        listenToFavorites()
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthStateChange), name: .AuthStateDidChange, object: nil)
    }

    @objc private func handleAuthStateChange() {
        stopListeningToFavorites()
        listenToFavorites()
    }

    func fetchFavorites() {
        guard let userId = userId else {
            favorites = []
            return
        }
        db.collection("users").document(userId).collection("favorites").order(by: "timestamp", descending: true).getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self?.favorites = documents.compactMap { document in
                try? document.data(as: Listing.self)
            }
        }
    }
    
    func listenToFavorites() {
        guard let userId = userId else {
            favorites = []
            return
        }
        listener = db.collection("users").document(userId).collection("favorites").order(by: "timestamp", descending: true).addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self?.favorites = documents.compactMap { document in
                try? document.data(as: Listing.self)
            }
        }
    }
    
    private func stopListeningToFavorites() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        stopListeningToFavorites()
        NotificationCenter.default.removeObserver(self)
    }
}
