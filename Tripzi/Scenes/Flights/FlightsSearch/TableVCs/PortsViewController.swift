//
//  PortsViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

final class PortsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private let viewModel: FlightsViewModel
    private var country: Country
    private var selectedPort: Port?
    private var tableView: UITableView!
    weak var delegate: PortSelectionDelegate?
    private var selectedTextField: CustomTextField
    
    // MARK: - Initialisers
    
    init(viewModel: FlightsViewModel, country: Country, delegate: PortSelectionDelegate?, selectedTextField: CustomTextField) {
        self.viewModel = viewModel
        self.country = country
        self.delegate = delegate
        self.selectedTextField = selectedTextField
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .uniModal
        title = "Airports in \(country.name)"
        setupTableView()
        fetchPorts()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    }
    
    // MARK: - Actions
    
    @objc private func doneTapped() {
        if let selectedPort = selectedPort {
            delegate?.didChoosePort(portName: selectedPort.name, forField: selectedTextField)
            viewModel.didChoosePort(port: selectedPort, forField: selectedTextField)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - UI Setup
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PortCell")
        view.addSubview(tableView)
    }
    
    // MARK: - Fetching Data
    
    private func fetchPorts() {
        viewModel.fetchPorts(for: country.code) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortCell", for: indexPath)
        let port = viewModel.ports[indexPath.row]
        cell.textLabel?.text = "\(port.name) (\(port.code))"
        cell.accessoryType = (selectedPort?.name == port.name) ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPort = viewModel.ports[indexPath.row]
        tableView.reloadData()
    }
}
