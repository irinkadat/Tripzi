//
//  FlightDetailsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 23.07.24.
//

import Foundation
import Stripe
import NetService

struct PaymentIntentResponse: Decodable {
    let clientSecret: String?
}

final class FlightDetailsViewModel: NSObject {
    // MARK: - Properties

    weak var authenticationContextProvider: AuthenticationContextProvider?
    var updateUIForPaymentResult: ((Bool) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var requestApplePay: (() -> Void)?
    private var networkService = NetworkService()
    var paymentIntentClientSecret: String?
    var price: Double
    
    init(price: Double) {
        self.price = price
        super.init()
        fetchPaymentIntentClientSecret()
    }
    
    // MARK: - Fetch Payment Intent Client Secret

    private func fetchPaymentIntentClientSecret() {
        let backendUrl = "https://tripzi.glitch.me/create-payment-intent"
        let body: [String: Any] = [
            "amount": Int(price) * 100,
            "currency": "usd"
        ]
        
        networkService.postData(urlString: backendUrl, body: body, headers: ["Content-Type": "application/json"]) { (result: Result<PaymentIntentResponse, Error>) in
            switch result {
            case .success(let response):
                if let clientSecret = response.clientSecret {
                    self.paymentIntentClientSecret = clientSecret
                } else {
                    print("Invalid response from server")
                }
            case .failure(let error):
                print("Error fetching payment intent client secret: \(error)")
            }
        }
    }
    
    // MARK: - Payment Handling

    func didTapPayButton(cardParams: STPPaymentMethodCardParams, email: String?, country: String?) {
        guard let clientSecret = paymentIntentClientSecret else {
            print("Missing payment intent client secret")
            return
        }
        
        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.email = email
        billingDetails.address = STPPaymentMethodAddress()
        billingDetails.address?.country = country
        
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        guard let authenticationContextProvider = authenticationContextProvider else {
            print("Missing authentication context provider")
            return
        }
        
        STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: authenticationContextProvider as! STPAuthenticationContext) { status, _, error in
            switch status {
            case .succeeded:
                self.updateUIForPaymentResult?(true)
            case .failed:
                self.updateUIForPaymentResult?(false)
                print("Payment failed: \(String(describing: error))")
            case .canceled:
                self.updateUIForPaymentResult?(false)
                print("User canceled the payment")
            @unknown default:
                fatalError()
            }
        }
    }
    
    func didTapApplePayButton() {
        requestApplePay?()
    }
    
    func handlePaymentResult(status: STPPaymentHandlerActionStatus, error: Error?) {
        switch status {
        case .succeeded:
            self.updateUIForPaymentResult?(true)
            print("Payment successful")
        case .failed:
            self.updateUIForPaymentResult?(false)
            print("Payment failed: \(String(describing: error))")
        case .canceled:
            self.updateUIForPaymentResult?(false)
            print("User canceled the payment")
        @unknown default:
            fatalError()
        }
    }
    
    func convertPaymentStatus(_ status: STPPaymentStatus) -> STPPaymentHandlerActionStatus {
        switch status {
        case .success:
            return .succeeded
        case .error:
            return .failed
        case .userCancellation:
            return .canceled
        @unknown default:
            return .failed
        }
    }
}
