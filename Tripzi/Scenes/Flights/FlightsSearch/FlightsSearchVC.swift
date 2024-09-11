//
//  FlightsSearchVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit
import Combine

final class FlightsSearchVC: UIViewController, PortSelectionDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var viewModel: FlightsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedTextField: CustomTextField?
    
    private let datePicker = UIDatePicker()
    
    // MARK: - UI Elements
    
    private let originField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "From"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .uniModal
        textField.tag = 1
        return textField
    }()
    
    private let destinationField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "To"
        textField.backgroundColor = .uniModal
        textField.borderStyle = .roundedRect
        textField.tag = 2
        return textField
    }()
    
    private let departureDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Departure Date (dd-MM-yyyy)"
        textField.backgroundColor = .uniModal
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let seeAllDestinationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.uniCo, for: .normal)
        button.tintColor = .uniCo
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
        button.clipsToBounds = true
        button.layer.cornerRadius = 26
        button.backgroundColor = .uniButton
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
        viewModel.portSelectionDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDatePicker()
        setupSuggestionTableView()
        setupBindings()
        setupTapGesture()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .uniModal
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
            
            seeAllDestinationsButton.topAnchor.constraint(equalTo: departureDateField.bottomAnchor, constant: 150),
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
    
    // MARK: - Actions
    
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
    }
    
    @objc private func didTapDestinationField() {
        selectedTextField = destinationField
        seeAllDestinationsButton.isHidden = false
        suggestionTableView.isHidden = false
        updateSuggestionTableViewConstraints()
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
        guard let departureDate = departureDateField.text, !departureDate.isEmpty else {
            showErrorAlert("Please enter a departure date.")
            return
        }
        
        guard let originPort = viewModel.selectedOriginPort else {
            showErrorAlert("Please select an origin port.")
            return
        }
        
        guard let destinationPort = viewModel.selectedDestinationPort else {
            showErrorAlert("Please select a destination port.")
            return
        }
        
        viewModel.performSearch(originPort: originPort, destinationPort: destinationPort, departureDateString: departureDate, completion: completion)
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showCountries() {
        guard let selectedTextField = selectedTextField else {
            return
        }
        let countriesViewController = CountriesViewController(viewModel: viewModel, delegate: self, selectedTextField: selectedTextField)
        let navigationController = UINavigationController(rootViewController: countriesViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func showPorts(for country: Country) {
        guard let selectedTextField = selectedTextField else {
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
                self?.suggestionTableView.isHidden = ports.isEmpty
                self?.suggestionTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(errorMessage)
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
        
        viewModel.handleTextChange(newText: newText)
        
        return true
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        let port = viewModel.ports[indexPath.row]
        cell.textLabel?.text = port.name
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedTextField = selectedTextField else { return }
        viewModel.selectPort(at: indexPath.row, forField: selectedTextField)
        suggestionTableView.isHidden = true
    }
    
    // MARK: - PortSelectionDelegate
    func didChoosePort(portName: String, forField: CustomTextField) {
        forField.text = portName
    }
    
    func didUpdateSuggestions() {
        suggestionTableView.isHidden = viewModel.ports.isEmpty
        suggestionTableView.reloadData()
    }
}
