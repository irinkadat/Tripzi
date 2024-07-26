//
//  CheckoutViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 23.07.24.
//

import UIKit
import Stripe
import PassKit

protocol AuthenticationContextProvider: AnyObject {}

final class CheckoutViewController: UIViewController, STPApplePayContextDelegate, STPAuthenticationContext, AuthenticationContextProvider {
    
    // MARK: - Properties

    var viewModel: FlightDetailsViewModel
    let paymentButton = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
    let orPayWithCardLabel = UILabel()
    let cardTextField = STPPaymentCardTextField()
    let emailTextField = UITextField()
    let locationTextField = UITextField()
    let payButton = UIButton(type: .system)
    let customApplePayButton = UIButton(type: .system)
    
    // MARK: - Initializer

    init(price: Double) {
        self.viewModel = FlightDetailsViewModel(price: price)
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
        viewModel.authenticationContextProvider = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .uniBackground
        setupUI()
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        setupApplePayButton()
        setupOrPayWithCardLabel()
        setupCardTextField()
        setupEmailTextField()
        setupLocationTextField()
        setupPayButton()
    }
    
    private func setupApplePayButton() {
        customApplePayButton.setTitle(" Pay", for: .normal)
        customApplePayButton.setTitleColor(.white, for: .normal)
        customApplePayButton.backgroundColor = .uniButton
        customApplePayButton.layer.cornerRadius = 16
        customApplePayButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        customApplePayButton.addTarget(self, action: #selector(didTapApplePayButton), for: .touchUpInside)
        customApplePayButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customApplePayButton)
        
        NSLayoutConstraint.activate([
            customApplePayButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            customApplePayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customApplePayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customApplePayButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupOrPayWithCardLabel() {
        orPayWithCardLabel.text = "Or pay with card"
        orPayWithCardLabel.textAlignment = .center
        orPayWithCardLabel.textColor = .gray
        orPayWithCardLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(orPayWithCardLabel)
        
        NSLayoutConstraint.activate([
            orPayWithCardLabel.topAnchor.constraint(equalTo: customApplePayButton.bottomAnchor, constant: 20),
            orPayWithCardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orPayWithCardLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCardTextField() {
        let cardContainer = CustomStyledView()
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardContainer)
        
        cardTextField.translatesAutoresizingMaskIntoConstraints = false
        cardTextField.borderWidth = 0
        cardContainer.addSubview(cardTextField)
        
        let cardLabel = UILabel()
        cardLabel.text = "Card Information"
        cardLabel.font = UIFont.systemFont(ofSize: 14)
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardLabel)
        
        NSLayoutConstraint.activate([
            cardLabel.topAnchor.constraint(equalTo: orPayWithCardLabel.bottomAnchor, constant: 20),
            cardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainer.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 10),
            cardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardTextField.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 10),
            cardTextField.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 10),
            cardTextField.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -10),
            cardTextField.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -10),
            cardContainer.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupEmailTextField() {
        let emailContainer = CustomStyledView()
        emailContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailContainer)
        
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailContainer.addSubview(emailTextField)
        
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: cardTextField.bottomAnchor, constant: 26),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailContainer.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailContainer.topAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: emailContainer.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainer.trailingAnchor, constant: -10),
            emailTextField.bottomAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: -10),
            emailContainer.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupLocationTextField() {
        let locationContainer = CustomStyledView()
        locationContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationContainer)
        
        locationTextField.placeholder = "Location"
        locationTextField.borderStyle = .none
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationContainer.addSubview(locationTextField)
        
        let locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 26),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationContainer.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            locationContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationTextField.topAnchor.constraint(equalTo: locationContainer.topAnchor, constant: 10),
            locationTextField.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor, constant: 10),
            locationTextField.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor, constant: -10),
            locationTextField.bottomAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: -10),
            locationContainer.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupPayButton() {
        payButton.setTitle("Pay", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .uniButton
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        payButton.layer.cornerRadius = 16
        payButton.addAction(UIAction(handler: { _ in self.didTapPayButton() }), for: .touchUpInside)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            payButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 46),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            payButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Bind ViewModel

    private func bindViewModel() {
        viewModel.updateUIForPaymentResult = { [weak self] success in
            DispatchQueue.main.async {
                let message = success ? "Payment successful" : "Payment failed"
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        viewModel.showAlert = { [weak self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.requestApplePay = { [weak self] in
            self?.handleApplePayRequest()
        }
    }
    
    // MARK: - Button Actions

    func didTapPayButton() {
        viewModel.didTapPayButton(
            cardParams: cardTextField.paymentMethodParams.card!,
            email: emailTextField.text,
            country: locationTextField.text
        )
    }
    
    @objc func didTapApplePayButton() {
        viewModel.didTapApplePayButton()
    }
    
    // MARK: - Apple Pay Handling

    func handleApplePayRequest() {
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: "merchant.com.example", country: "US", currency: "usd")
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Flight Ticket", amount: NSDecimalNumber(value: viewModel.price))
        ]
        
        if StripeAPI.canSubmitPaymentRequest(paymentRequest) {
            let paymentContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self)
            paymentContext?.presentApplePay()
        } else {
            let alert = UIAlertController(title: "Error", message: "Unable to submit payment request", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        guard let clientSecret = viewModel.paymentIntentClientSecret else {
            print("Missing payment intent client secret")
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing payment intent client secret"]))
            return
        }
        completion(clientSecret, nil)
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        let handlerStatus = viewModel.convertPaymentStatus(status)
        viewModel.handlePaymentResult(status: handlerStatus, error: error)
    }
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
