//
//  TipCardCollectionViewCell.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

final class TipCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "TipCardCollectionViewCell"
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.text = "★★★★★"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .uniCo.withAlphaComponent(0.7)
        return label
    }()
    
    private let tipTextLabel: CustomLabel = {
        let label = CustomLabel(style: .subtitle, fontSize: 14, textColor: .uniCo)
        label.numberOfLines = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: CustomLabel = {
        let label = CustomLabel(style: .title, fontSize: 14)
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
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(starsLabel)
        contentView.addSubview(textStackView)
        contentView.addSubview(spacerView)
        contentView.addSubview(userInfoStackView)
        contentView.addSubview(likesStackView)
        contentView.addSubview(dislikesStackView)
        
        userInfoStackView.addArrangedSubview(userImageView)
        userInfoStackView.addArrangedSubview(userNameLabel)
        
        likesStackView.addArrangedSubview(likesImageView)
        likesStackView.addArrangedSubview(likesLabel)
        
        dislikesStackView.addArrangedSubview(dislikesImageView)
        dislikesStackView.addArrangedSubview(dislikesLabel)
        
        textStackView.addArrangedSubview(tipTextLabel)
        
        NSLayoutConstraint.activate([
            starsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            starsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            textStackView.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 8),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            spacerView.topAnchor.constraint(equalTo: textStackView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: userInfoStackView.topAnchor, constant: -10),
            
            userInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userInfoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            userImageView.widthAnchor.constraint(equalToConstant: 24),
            userImageView.heightAnchor.constraint(equalToConstant: 24),
            
            likesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            likesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            dislikesStackView.trailingAnchor.constraint(equalTo: likesStackView.leadingAnchor, constant: -10),
            dislikesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
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
