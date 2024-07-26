//
//  PlacesListingViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

final class PlacesListingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isFavorited: Bool = false
    @Published var showLoginAlert: Bool = false
    
    // MARK: - Properties
    
    let listing: PlaceListing
    private var cancellables = Set<AnyCancellable>()
    
    init(listing: PlaceListing) {
        self.listing = listing
        checkIfFavorited()
    }
    
    // MARK: - Methods
    
    func saveToFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showLoginAlert = true
            return
        }
        
        var updatedListing = listing
        updatedListing.timestamp = Timestamp(date: Date())
        
        let db = Firestore.firestore()
        let favoritesRef = db.collection("users").document(userId).collection("favorites")
        
        do {
            try favoritesRef.document(updatedListing.id).setData(from: updatedListing)
            isFavorited = true
        } catch let error {
            print("Error saving favorite: \(error)")
        }
    }
    
    func removeFromFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showLoginAlert = true
            return
        }
        
        let db = Firestore.firestore()
        let favoritesRef = db.collection("users").document(userId).collection("favorites")
        
        favoritesRef.document(listing.id).delete { error in
            if let error = error {
                print("Error removing favorite: \(error)")
            } else {
                self.isFavorited = false
            }
        }
    }
    
    func checkIfFavorited() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let favoritesRef = db.collection("users").document(userId).collection("favorites")
        
        favoritesRef.document(listing.id).getDocument { document, error in
            if let document = document, document.exists {
                self.isFavorited = true
            } else {
                self.isFavorited = false
            }
        }
    }
}
