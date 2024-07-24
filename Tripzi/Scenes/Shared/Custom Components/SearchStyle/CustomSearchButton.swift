//
//  CustomSearchButton.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class CustomSearchButton: UIButton {
    
    private let styledView = CustomStyledView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 26
        layer.masksToBounds = true
        contentHorizontalAlignment = .center
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        styledView.isUserInteractionEnabled = false
        styledView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(styledView)
        sendSubviewToBack(styledView)
        
        
        NSLayoutConstraint.activate([
            styledView.topAnchor.constraint(equalTo: topAnchor),
            styledView.leadingAnchor.constraint(equalTo: leadingAnchor),
            styledView.trailingAnchor.constraint(equalTo: trailingAnchor),
            styledView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
