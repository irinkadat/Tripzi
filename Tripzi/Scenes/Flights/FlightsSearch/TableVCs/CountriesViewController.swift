//
//  CountriesViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

final class CountriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: FlightsViewModel
    private var tableView: UITableView!
    private var selectedCountry: Country?
    weak var delegate: PortSelectionDelegate?
    private var selectedTextField: CustomTextField

    init(viewModel: FlightsViewModel, delegate: PortSelectionDelegate?, selectedTextField: CustomTextField) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.selectedTextField = selectedTextField
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a Country"
        setupTableView()
        fetchCountries()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        view.addSubview(tableView)
    }

    private func fetchCountries() {
        viewModel.fetchCountries { [weak self] countries in
            self?.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = viewModel.countries[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = viewModel.countries[indexPath.row]
        let portsVC = PortsViewController(viewModel: viewModel, country: selectedCountry, delegate: delegate, selectedTextField: selectedTextField)
        navigationController?.pushViewController(portsVC, animated: true)
    }
}

