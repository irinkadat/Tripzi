//
//  CategoryCell.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

struct SearchCategory {
    let name: String
    let icon: UIImage
}

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 6),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            underlineView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            underlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: SearchCategory, isSelected: Bool) {
        iconImageView.image = category.icon
        nameLabel.text = category.name
        underlineView.isHidden = !isSelected
    }
}

#Preview {
    CategoryCell()
}
