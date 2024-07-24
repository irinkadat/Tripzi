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
    @Published var favorites: [Listing] = [] {
        didSet {
            onFavoritesUpdate?()
        }
    }
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    var onFavoritesUpdate: (() -> Void)?
    
    init() {
        listenToFavorites()
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthStateChange), name: .AuthStateDidChange, object: nil)
    }
    
    private func setupBindings() {
        $favorites
            .sink { [weak self] _ in
                self?.onFavoritesUpdate?()
            }
            .store(in: &cancellables)
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
    
    func configureCell(_ cell: CustomCollectionViewCell, with listing: Listing, completion: @escaping (UIViewController) -> Void) {
        cell.configure(with: listing) { [weak self] in
            guard self != nil else { return }
            let detailVM = SearchViewModel()
            detailVM.destinationDetails(for: listing.id) { detailedListing in
                guard let detailedListing = detailedListing else { return }
                DispatchQueue.main.async {
                    let destinationDetailsVC = DestinationDetailsVC()
                    destinationDetailsVC.listing = detailedListing
                    destinationDetailsVC.imageUrls = listing.imageUrls
                    completion(destinationDetailsVC)
                }
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
    
    func selectItem(at indexPath: IndexPath, completion: @escaping (UIViewController) -> Void) {
        let listing = favorites[indexPath.row]
        let detailVM = SearchViewModel()
        detailVM.destinationDetails(for: listing.id) { detailedListing in
            guard let detailedListing = detailedListing else { return }
            DispatchQueue.main.async {
                let destinationDetailsVC = DestinationDetailsVC()
                destinationDetailsVC.listing = detailedListing
                destinationDetailsVC.imageUrls = listing.imageUrls
                completion(destinationDetailsVC)
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
