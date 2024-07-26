//
//  InfoStatsView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

final class InfoStatsView: UIView {
     
    private let ratingLabel: CustomLabel = {
        let label = CustomLabel(style: .title, fontSize: 16)
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.text = "★★★★★"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemYellow.withAlphaComponent(0.7)
        return label
    }()
    
    private let openStatusLabel: UILabel = {
        let label = CustomLabel(style: .title, fontSize: 16)
        return label
    }()
    
    private let checkinsLabel: UILabel = {
        let label = CustomLabel(style: .title, fontSize: 16)
        return label
    }()
    
    private let reviewsLabel: UILabel = {
        let label = CustomLabel(style: .subtitle, fontSize: 12, textColor: .uniCo)
        label.text = "Check-ins"
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(mainStackView)
        
        leftStackView.addArrangedSubview(ratingLabel)
        leftStackView.addArrangedSubview(starsLabel)
        
        middleStackView.addArrangedSubview(openStatusLabel)
        
        rightStackView.addArrangedSubview(checkinsLabel)
        rightStackView.addArrangedSubview(reviewsLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(createDivider())
        mainStackView.addArrangedSubview(middleStackView)
        mainStackView.addArrangedSubview(createDivider())
        mainStackView.addArrangedSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 16
    }
    
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 30)
        ])
        return divider
    }
    
    func configure(rating: String, openStatus: String, openStatusColor: UIColor, checkins: String) {
        ratingLabel.text = rating
        openStatusLabel.text = openStatus
        openStatusLabel.textColor = openStatusColor
        checkinsLabel.text = checkins
    }
}
