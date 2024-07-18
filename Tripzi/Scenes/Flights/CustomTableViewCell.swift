//
//  CustomTableViewCell.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let routeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Itinerary details", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    private let economyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private let bestPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
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
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(routeLabel)
        stackView.addArrangedSubview(durationLabel)
        stackView.addArrangedSubview(detailsButton)
        
        horizontalStackView.addArrangedSubview(stackView)
        
        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.spacing = 4
        rightStackView.distribution = .fill
        
        let horisontalRightSV = UIStackView()
        horisontalRightSV.axis = .horizontal
        horisontalRightSV.alignment = .center
        horisontalRightSV.distribution = .fill
        horisontalRightSV.addArrangedSubview(economyLabel)
        horisontalRightSV.addArrangedSubview(bestPriceLabel)
        horisontalRightSV.spacing = 4
        
        let spacerView = UIView()
        spacerView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        rightStackView.addArrangedSubview(spacerView)
        
        rightStackView.addArrangedSubview(horisontalRightSV)
        
        let spacerView2 = UIView()
        spacerView2.heightAnchor.constraint(equalToConstant: 65).isActive = true
        rightStackView.addArrangedSubview(spacerView2)
        
        
        rightStackView.addArrangedSubview(priceLabel)
        
        let spacerView3 = UIView()
        spacerView3.heightAnchor.constraint(equalToConstant: 4).isActive = true
        rightStackView.addArrangedSubview(spacerView3)
        
        horizontalStackView.addArrangedSubview(rightStackView)
        
        contentView.addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with model: FlightModel) {
        timeLabel.text = model.time
        routeLabel.text = model.route
        durationLabel.text = model.duration
        priceLabel.text = model.price
        economyLabel.text = "ECONOMY"
        bestPriceLabel.text = "Best price"
    }
}

#Preview {
    CustomTableViewCell()
}
