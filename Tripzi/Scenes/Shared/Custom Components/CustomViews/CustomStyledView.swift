//
//  CustomStyledView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class CustomStyledView: UIView {
    
    private let borderLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        borderLayer.borderWidth = 0.5
        borderLayer.borderColor = UIColor.systemGray4.cgColor
        borderLayer.cornerRadius = 26
        borderLayer.frame = bounds
        borderLayer.masksToBounds = true
        borderLayer.shadowColor = UIColor.uniCo.cgColor
        borderLayer.shadowOpacity = 0.4
        borderLayer.shadowOffset = CGSize(width: 0, height: 1)
        borderLayer.shadowRadius = 2
        borderLayer.masksToBounds = false
        
        layer.addSublayer(borderLayer)
        layer.cornerRadius = 26
        layer.masksToBounds = true
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
    }
}

#Preview {
    CustomStyledView()
}
