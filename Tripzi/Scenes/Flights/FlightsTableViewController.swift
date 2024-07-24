//
//  FlightsTableViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit
import Combine

class FlightsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FlightsViewModelDelegate {
    var viewModel: FlightsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FlightsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FlightTableViewCell.self, forCellReuseIdentifier: FlightTableViewCell.identifier)
        return tableView
    }()
    
//    private let noFlightsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No flights searched"
//        label.textAlignment = .center
//        label.isHidden = true
//        return label
//    }()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
//        setupNoFlightsLabel()
        setupBindings()
        viewModel.flightsDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restartAnimations()
    }
    
    private func restartAnimations() {
        for cell in tableView.visibleCells {
            if let flightCell = cell as? FlightTableViewCell {
                flightCell.startPlaneAnimation()
            }
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
//    private func setupNoFlightsLabel() {
//        view.addSubview(noFlightsLabel)
//        noFlightsLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            noFlightsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            noFlightsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
    
    private func setupBindings() {
        viewModel.$searchedFlights
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.searchedFlights.count
//        noFlightsLabel.isHidden = count > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as? FlightTableViewCell else {
            return UITableViewCell()
        }
        viewModel.selectFlightOption(at: indexPath.row)
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = FlightDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let flightCell = cell as? FlightTableViewCell {
            flightCell.startPlaneAnimation()
        }
    }
    
    // MARK: - FlightsViewModelDelegate
    func didUpdateFlightSegments() {
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

