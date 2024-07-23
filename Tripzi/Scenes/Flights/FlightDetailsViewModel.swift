//
//  FlightDetailsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 23.07.24.
//

import Foundation
import Stripe

class FlightDetailsViewModel: NSObject {
    weak var authenticationContextProvider: AuthenticationContextProvider?
    
    var updateUIForPaymentResult: ((Bool) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var requestApplePay: (() -> Void)?
    
    var paymentIntentClientSecret: String?
    var price: Double
    
    init(price: Double) {
        self.price = price
        super.init()
        fetchPaymentIntentClientSecret()
    }
    
    private func fetchPaymentIntentClientSecret() {
        let backendUrl = URL(string: "https://tripzi.glitch.me/create-payment-intent")!
        var request = URLRequest(url: backendUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "amount": Int(price) * 100,
            "currency": "usd"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching payment intent client secret: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let clientSecret = json["clientSecret"] as? String {
                    self.paymentIntentClientSecret = clientSecret
                } else {
                    print("Invalid response from server")
                }
            } catch {
                print("Error parsing JSON response: \(error)")
            }
        }
        task.resume()
    }
    
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
