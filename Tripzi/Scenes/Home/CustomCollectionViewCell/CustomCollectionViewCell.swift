//
//  CustomCollectionViewCell.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import UIKit
import SwiftUI

final class CustomCollectionViewCell: UICollectionViewCell {
    private var hostingController: UIHostingController<PlacesListingView>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with listing: Listing, onTap: @escaping () -> Void) {
        let viewModel = PlacesListingViewModel(listing: listing)
        let hostingController = UIHostingController(rootView: PlacesListingView(viewModel: viewModel, onTap: onTap))
        self.hostingController = hostingController
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
