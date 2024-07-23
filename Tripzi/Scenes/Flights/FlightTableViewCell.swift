//
//  FlightTableViewCell.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    
    static let identifier = "FlightTableViewCell"
    
    private let departureDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let departureTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let departureTimezoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let flightDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let flightPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let flightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "airplane"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .greenPrimary
        return imageView
    }()
    
    private let flightDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let arrivalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let arrivalTimezoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        let departureStack = UIStackView(arrangedSubviews: [departureDateLabel, departureTimeLabel, departureTimezoneLabel])
        departureStack.axis = .vertical
        departureStack.spacing = 4
        containerView.addSubview(departureStack)
        
        let arrivalStack = UIStackView(arrangedSubviews: [flightDetailLabel, arrivalTimeLabel, arrivalTimezoneLabel])
        arrivalStack.axis = .vertical
        arrivalStack.spacing = 4
        arrivalStack.alignment = .trailing
        containerView.addSubview(arrivalStack)
        
        let flightStack = UIStackView(arrangedSubviews: [flightImageView, flightDurationLabel, flightPriceLabel])
        flightStack.axis = .vertical
        flightStack.alignment = .center
        flightStack.spacing = 4
        containerView.addSubview(flightStack)
        
        departureStack.translatesAutoresizingMaskIntoConstraints = false
        arrivalStack.translatesAutoresizingMaskIntoConstraints = false
        flightStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            departureStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            departureStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            flightStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            flightStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            arrivalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            arrivalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
        layoutIfNeeded()
        startPlaneAnimation()
    }
    
    func startPlaneAnimation() {
        let startPosition = -containerView.bounds.width / 4
        let endPosition = containerView.bounds.width / 4
        
        flightImageView.transform = CGAffineTransform(translationX: startPosition, y: 0)
        
        UIView.animate(withDuration: 1.8, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.flightImageView.transform = CGAffineTransform(translationX: endPosition, y: 0)
        }, completion: nil)
    }
    
    func configure(with model: FlightSegment, price: FlightPrice) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        if let departureDate = dateFormatter.date(from: model.departureDateTime) {
            dateFormatter.dateFormat = "HH:mm"
            departureDateLabel.text = dateFormatter.string(from: departureDate)
            dateFormatter.dateFormat = "HH:mm"
            departureTimeLabel.text = dateFormatter.string(from: departureDate)
        } else {
            departureDateLabel.text = model.departureDateTime
            departureTimeLabel.text = model.departureDateTime
        }

        departureTimezoneLabel.text = model.departureAirportCode
        flightDurationLabel.text = "Duration: \(model.journeyDurationInMillis / 60000) mins"
        flightPriceLabel.text = "Price: \(price.amount) \(price.currencyCode)"
 

        flightDetailLabel.text = model.arrivalDateTime

        let arrivalTime = String(model.arrivalDateTime.suffix(5))
        arrivalTimeLabel.text = arrivalTime
        
        arrivalTimezoneLabel.text = model.arrivalAirportCode
    }
}

#Preview {
    FlightTableViewCell()
}
