//
//  FlightsSearchVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit
import Combine

class FlightsSearchVC: UIViewController, PortSelectionDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var viewModel: FlightsViewModel
    private var cancellables = Set<AnyCancellable>()
    private var suggestions: [Port] = []
    
    private var selectedTextField: CustomTextField2?
    private var selectedOriginPort: Port?
    private var selectedDestinationPort: Port?
    
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
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.isHidden = true
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        let attributedTitle = NSAttributedString(string: "🌍 See all destinations", attributes: attributes)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
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
    
    private let suggestionTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: FlightsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDatePicker()
        setupSuggestionTableView()
        setupBindings()
        setupTapGesture()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupTextFields()
        setupButtons()
        setupConstraints()
    }
    
    private func setupTextFields() {
        view.addSubview(originField)
        view.addSubview(destinationField)
        view.addSubview(departureDateField)
        
        originField.translatesAutoresizingMaskIntoConstraints = false
        destinationField.translatesAutoresizingMaskIntoConstraints = false
        departureDateField.translatesAutoresizingMaskIntoConstraints = false
        
        originField.delegate = self
        destinationField.delegate = self
    }
    
    private func setupButtons() {
        view.addSubview(seeAllDestinationsButton)
        view.addSubview(searchButton)
    }
    
    private func setupConstraints() {
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
            
            seeAllDestinationsButton.topAnchor.constraint(equalTo: departureDateField.bottomAnchor, constant: 100),
            seeAllDestinationsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            seeAllDestinationsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchButton.heightAnchor.constraint(equalToConstant: 52),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
    
    @objc private func didTapOriginField() {
        selectedTextField = originField
        seeAllDestinationsButton.isHidden = false
        suggestionTableView.isHidden = false
        updateSuggestionTableViewConstraints()
        print("Origin field tapped")
    }
    
    @objc private func didTapDestinationField() {
        selectedTextField = destinationField
        seeAllDestinationsButton.isHidden = false
        suggestionTableView.isHidden = false
        updateSuggestionTableViewConstraints()
        print("Destination field tapped")
    }
    
    @objc private func didTapSeeAllDestinationsButton() {
        print("See all destinations button tapped")
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
        guard let selectedTextField = selectedTextField else {
            print("selectedTextField is nil in showCountries")
            return
        }
        let countriesViewController = CountriesViewController(viewModel: viewModel, delegate: self, selectedTextField: selectedTextField)
        let navigationController = UINavigationController(rootViewController: countriesViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func showPorts(for country: Country) {
        guard let selectedTextField = selectedTextField else {
            print("selectedTextField is nil in showPorts")
            return
        }
        let portsViewController = PortsViewController(viewModel: viewModel, country: country, delegate: self, selectedTextField: selectedTextField)
        let navigationController = UINavigationController(rootViewController: portsViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setupSuggestionTableView() {
        suggestionTableView.delegate = self
        suggestionTableView.dataSource = self
        
        let backgroundView = CustomStyledView()
        suggestionTableView.backgroundView = backgroundView
        
        updateSuggestionTableViewConstraints()
    }
    
    private func updateSuggestionTableViewConstraints() {
        suggestionTableView.removeFromSuperview()
        suggestionTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(suggestionTableView)
        
        guard let selectedTextField = selectedTextField else {
            return
        }
        
        NSLayoutConstraint.activate([
            suggestionTableView.topAnchor.constraint(equalTo: selectedTextField.bottomAnchor, constant: 8),
            suggestionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            suggestionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            suggestionTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        suggestionTableView.backgroundView?.frame = suggestionTableView.bounds
        suggestionTableView.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupBindings() {
        viewModel.$ports
            .receive(on: RunLoop.main)
            .sink { [weak self] ports in
                self?.suggestions = ports
                self?.suggestionTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndSuggestions))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboardAndSuggestions() {
        view.endEditing(true)
        suggestionTableView.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            suggestionTableView.isHidden = true
        } else {
            viewModel.fetchPortSuggestions(for: newText) { [weak self] ports in
                self?.suggestions = ports
                self?.suggestionTableView.isHidden = false
                self?.suggestionTableView.reloadData()
            }
        }
        
        return true
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        let port = suggestions[indexPath.row]
        cell.textLabel?.text = port.name
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPort = suggestions[indexPath.row]
        selectedTextField?.text = selectedPort.name
        suggestionTableView.isHidden = true
        if let selectedTextField = selectedTextField {
            didChoosePort(port: selectedPort, forField: selectedTextField)
        }
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
