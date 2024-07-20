//
//  CustomTextField2.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class CustomTextField2: UITextField {
    
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
        borderStyle = .none
        layer.cornerRadius = 26
        layer.masksToBounds = true
        setLeftPaddingPoints(16)
        
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

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
