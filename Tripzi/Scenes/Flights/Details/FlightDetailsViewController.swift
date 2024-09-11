//
//  FlightDetailsViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 23.07.24.
//

import UIKit

final class FlightDetailsViewController: UIViewController {
    // MARK: - Properties

    var viewModel: FlightsViewModel
    private let flightCell = FlightTableViewCell(style: .default, reuseIdentifier: FlightTableViewCell.identifier)
    private var checkoutViewController: CheckoutViewController?

    init(viewModel: FlightsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCustomBackButtonStyle()
        flightCell.configure(with: viewModel)
        addCheckoutViewController(price: Double(viewModel.flightPrice) ?? 0.0)
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .uniBackground
        flightCell.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(flightCell)
        
        NSLayoutConstraint.activate([
            flightCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            flightCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flightCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flightCell.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func addCheckoutViewController(price: Double) {
        let checkoutVC = CheckoutViewController(price: price)
        addChild(checkoutVC)
        view.addSubview(checkoutVC.view)
        checkoutVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkoutVC.view.topAnchor.constraint(equalTo: flightCell.bottomAnchor, constant: 20),
            checkoutVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        checkoutVC.didMove(toParent: self)
        checkoutViewController = checkoutVC
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
