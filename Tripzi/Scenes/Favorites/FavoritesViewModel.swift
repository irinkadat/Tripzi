//
//  FavoritesViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

final class FavoritesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    var onFavoritesUpdate: (() -> Void)?
    var onFavoritesStateChange: ((Bool) -> Void)?
    
    @Published var hasFavorites: Bool = false {
        didSet {
            onFavoritesStateChange?(hasFavorites)
        }
    }
    
    @Published var favorites: [PlaceListing] = [] {
        didSet {
            onFavoritesUpdate?()
            hasFavorites = !favorites.isEmpty
        }
    }
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.handleAuthStateChange()
        }
        setupNotificationObservers()
    }
    
    // MARK: - Setup Methods
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthStateChange), name: .AuthStateDidChange, object: nil)
        handleAuthStateChange() //
    }
    
    private func setupBindings() {
        $favorites
            .sink { [weak self] _ in
                self?.onFavoritesUpdate?()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Notification Handlers
    
    @objc private func handleAuthStateChange() {
        stopListeningToFavorites()
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.listenToFavorites()
            }
        } else {
            favorites = []
        }
    }
    
    // MARK: - Data Fetching Methods
    
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
                try? document.data(as: PlaceListing.self)
            }
        }
    }
    
    func fetchDetailedListing(for listingId: String, completion: @escaping (PlaceListing?) -> Void) {
        let detailVM = SearchViewModel()
        detailVM.destinationDetails(for: listingId) { detailedListing in
            completion(detailedListing)
        }
    }
    
    func configureCell(at indexPath: IndexPath, completion: @escaping (PlaceListing, PlaceListing, [String]) -> Void) {
        let listing = favorites[indexPath.row]
        fetchDetailedListing(for: listing.id) { detailedListing in
            guard let detailedListing = detailedListing else { return }
            completion(listing, detailedListing, listing.imageUrls)
        }
    }
    
    func selectItem(at indexPath: IndexPath, completion: @escaping (PlaceListing, PlaceListing, [String]) -> Void) {
        let listing = favorites[indexPath.row]
        fetchDetailedListing(for: listing.id) { detailedListing in
            guard let detailedListing = detailedListing else { return }
            completion(listing, detailedListing, listing.imageUrls)
        }
    }
    
    // MARK: - Listener Methods
    
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
                try? document.data(as: PlaceListing.self)
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
