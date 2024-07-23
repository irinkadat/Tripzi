//
//  PaymentsVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 24.07.24.
//

import UIKit

final class PaymentsVC: UIViewController {
    let paymentsLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Welcome to Tripzi!
        
        Tripzi makes managing your payments and payouts easy and secure. Here is all you need to know about handling your financial transactions within the Tripzi app:
        
        Payments
        Tripzi provides a seamless and secure way to pay for your travel bookings. You can use various payment methods including credit cards, debit cards, and more. Our system ensures that your payment details are protected with industry-standard encryption.
        
        Supported Payment Methods
        * Credit Cards: Visa, MasterCard, American Express, Discover
        * Debit Cards: Most major banks
        * Other Methods: Apple Pay
        
        How to Make a Payment
        1. Select your desired travel booking.
        2. Proceed to the payment section.
        3. Choose your preferred payment method.
        4. Enter the required details and confirm your payment.
        5. You will receive a confirmation email once the payment is successful.
        
        Payouts
        If you are a host or service provider on Tripzi, you will receive payouts for the services you offer.
        Tripzi ensures timely and secure payouts directly to your bank account.
        
        Payout Methods
        * Direct Bank Transfer: Receive payments directly to your bank account.
        * ApplePay: Quick and easy payouts to your PayPal account.
        
        Payout Schedule
        Payouts are processed on a weekly basis. Depending on your payout method, it may take a few days for the
        funds to appear in your account.
        
        At Tripzi, we prioritize the security and convenience of our users' financial transactions. Should you
        have any questions or need assistance, our support team is available 24/7 to help you.
        
        Thank you for using Tripzi!
        
        The Tripzi Team
        """
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButtonStyle()
        view.backgroundColor = .white
        configureNavigationBarTitle(title: "Payments & Payouts")
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(paymentsLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            paymentsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            paymentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            paymentsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            paymentsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

#Preview {
    PaymentsVC()
}
