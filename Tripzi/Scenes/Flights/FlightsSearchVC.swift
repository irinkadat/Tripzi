//
//  FlightsSearchVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class FlightsSearchVC: UIViewController, PortSelectionDelegate {
    var viewModel: FlightsViewModel
    
    init(viewModel: FlightsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedOriginCountry: Country?
    private var selectedDestinationCountry: Country?
    private var selectedOriginPort: Port?
    private var selectedDestinationPort: Port?
    
    private var selectedTextField: CustomTextField2?
    private let datePicker = UIDatePicker()
    
    private let originField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.placeholder = "From"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let destinationField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.placeholder = "To"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let departureDateField: CustomTextField2 = {
        let textField = CustomTextField2()
        textField.placeholder = "Departure Date (dd-MM-yyyy)"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let seeAllDestinationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all destinations", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "globe"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDatePicker()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(originField)
        view.addSubview(destinationField)
        view.addSubview(departureDateField)
        view.addSubview(seeAllDestinationsButton)
        view.addSubview(searchButton)
        
        originField.translatesAutoresizingMaskIntoConstraints = false
        destinationField.translatesAutoresizingMaskIntoConstraints = false
        departureDateField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            originField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            originField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            originField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            destinationField.topAnchor.constraint(equalTo: originField.bottomAnchor, constant: 20),
            destinationField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            departureDateField.topAnchor.constraint(equalTo: destinationField.bottomAnchor, constant: 20),
            departureDateField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            departureDateField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            seeAllDestinationsButton.topAnchor.constraint(equalTo: departureDateField.bottomAnchor, constant: 20),
            seeAllDestinationsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            seeAllDestinationsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchButton.heightAnchor.constraint(equalToConstant: 52),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }
    
    private func setupActions() {
        originField.addTarget(self, action: #selector(didTapOriginField), for: .touchDown)
        destinationField.addTarget(self, action: #selector(didTapDestinationField), for: .touchDown)
        seeAllDestinationsButton.addTarget(self, action: #selector(didTapSeeAllDestinationsButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        departureDateField.inputView = datePicker
        setDateToCurrentDate()
    }
    
    private func setDateToCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        departureDateField.text = dateFormatter.string(from: Date())
    }
    
    @objc private func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        departureDateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapOriginField() {
        selectedTextField = originField
        seeAllDestinationsButton.isHidden = false
    }
    
    @objc private func didTapDestinationField() {
        selectedTextField = destinationField
        seeAllDestinationsButton.isHidden = false
    }
    
    @objc private func didTapSeeAllDestinationsButton() {
        viewModel.fetchCountries { [weak self] countries in
            self?.showCountries()
        }
    }
    
    @objc private func didTapSearchButton() {
        performSearch { [weak self] in
            self?.dismiss(animated: true) {
                let flightsViewController = FlightsViewController()
                self?.navigationController?.pushViewController(flightsViewController, animated: true)
            }
        }
    }
    
    private func performSearch(completion: @escaping () -> Void) {
        guard let selectedOriginPort = selectedOriginPort,
              let selectedDestinationPort = selectedDestinationPort,
              let departureDate = departureDateField.text else {
            showErrorAlert("Please select both origin and destination ports and enter a departure date.")
            return
        }
        
        viewModel.performSearch(originPort: selectedOriginPort, destinationPort: selectedDestinationPort, departureDate: departureDate, completion: completion)
    }
    
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showCountries() {
        let countriesViewController = CountriesViewController(viewModel: viewModel, delegate: self, selectedTextField: selectedTextField!)
        let navigationController = UINavigationController(rootViewController: countriesViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func showPorts(for country: Country) {
        let portsViewController = PortsViewController(viewModel: viewModel, country: country, delegate: self, selectedTextField: selectedTextField!)
        let navigationController = UINavigationController(rootViewController: portsViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - PortSelectionDelegate
    func didChoosePort(port: Port, forField: CustomTextField2) {
        forField.text = port.name
        if forField == originField {
            selectedOriginPort = port
        } else if forField == destinationField {
            selectedDestinationPort = port
        }
    }
}
