//
//  FlightsViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//
//

import Combine
import UIKit

class FlightsViewController: UIViewController {
    private let searchFlights = CustomSearchBar()
    private let viewModel = FlightsViewModel()
    private let containerView = UIView()
    private var cancellables = Set<AnyCancellable>()
    
    private let noFlightsLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops no flights searched yet"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noFlights")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomSearchBar()
        setupContainerView()
        setupIllustrationAndNoFlightsLabel()
        addSearchBarTapGesture()
        embedFlightsTableViewController()
        setupBindings()
    }
    
    private func setupCustomSearchBar() {
        searchFlights.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchFlights)
        
        NSLayoutConstraint.activate([
            searchFlights.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            searchFlights.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchFlights.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchFlights.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: searchFlights.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupIllustrationAndNoFlightsLabel() {
        view.addSubview(illustrationImageView)
        view.addSubview(noFlightsLabel)
        
        illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
        noFlightsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            illustrationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            illustrationImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            illustrationImageView.widthAnchor.constraint(equalToConstant: 200),
            illustrationImageView.heightAnchor.constraint(equalToConstant: 200),
            
            noFlightsLabel.topAnchor.constraint(equalTo: illustrationImageView.bottomAnchor, constant: 10),
            noFlightsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addSearchBarTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        searchFlights.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapSearchBar() {
        let searchVC = FlightsSearchVC(viewModel: viewModel)
        searchVC.modalPresentationStyle = .popover
        present(searchVC, animated: true, completion: nil)
    }
    
    private func embedFlightsTableViewController() {
        let flightsTableViewController = FlightsTableViewController(viewModel: viewModel)
        addChild(flightsTableViewController)
        containerView.addSubview(flightsTableViewController.view)
        flightsTableViewController.view.frame = containerView.bounds
        flightsTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flightsTableViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            flightsTableViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            flightsTableViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            flightsTableViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        flightsTableViewController.didMove(toParent: self)
    }
    
    private func setupBindings() {
        viewModel.$hasSearchedFlights
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasSearchedFlights in
                self?.noFlightsLabel.isHidden = hasSearchedFlights
                self?.illustrationImageView.isHidden = hasSearchedFlights
            }
            .store(in: &cancellables)
    }
}

#Preview {
    FlightsViewController()
}
