//
//  IconTextStackView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

final class IconTextStackView: UIStackView {
    
    init(icon: UIImage?, text: String) {
        super.init(frame: .zero)
        setupView(icon: icon, text: text)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(icon: UIImage?, text: String) {
        let iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = .gray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let textLabel = CustomLabel(style: .subtitle, fontSize: 15)
        textLabel.text = text
        
        addArrangedSubview(iconImageView)
        addArrangedSubview(textLabel)
        
        axis = .horizontal
        spacing = 8
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
}
