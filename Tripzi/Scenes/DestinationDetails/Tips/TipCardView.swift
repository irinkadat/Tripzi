//
//  TipCardView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class TipCardView: UIView {
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.text = "★★★★★"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }()
    
    private let tipTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dislikesImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsdown"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dislikesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let likesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dislikesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
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
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        addSubview(starsLabel)
        addSubview(tipTextLabel)
        addSubview(userInfoStackView)
        addSubview(textStackView)
        
        userInfoStackView.addArrangedSubview(userImageView)
        userInfoStackView.addArrangedSubview(userNameLabel)
        
        likesStackView.addArrangedSubview(likesImageView)
        likesStackView.addArrangedSubview(likesLabel)
        
        dislikesStackView.addArrangedSubview(dislikesImageView)
        dislikesStackView.addArrangedSubview(dislikesLabel)
        
        userInfoStackView.addArrangedSubview(likesStackView)
        userInfoStackView.addArrangedSubview(dislikesStackView)
        
        textStackView.addArrangedSubview(tipTextLabel)
        
        NSLayoutConstraint.activate([
            starsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            starsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            textStackView.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 8),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            userInfoStackView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 10),
            userInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            userInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            userImageView.widthAnchor.constraint(equalToConstant: 32),
            userImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(tipText: String, UserName: String, likes: String, dislikes: String, userImage: UIImage) {
        tipTextLabel.text = tipText
        userNameLabel.text = UserName
        likesLabel.text = likes
        dislikesLabel.text = dislikes
        userImageView.image = userImage
    }
}
