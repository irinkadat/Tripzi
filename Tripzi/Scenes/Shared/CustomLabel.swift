//
//  CustomLabel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class CustomLabel: UILabel {
    
    enum LabelStyle {
        case title
        case subtitle
    }
    
    var style: LabelStyle = .title {
        didSet {
            applyStyle()
        }
    }
    
    var customFontSize: CGFloat? {
        didSet {
            applyStyle()
        }
    }
    
    var customTextColor: UIColor? {
        didSet {
            applyStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
        applyStyle()
    }
    
    init(style: LabelStyle, fontSize: CGFloat? = nil, textColor: UIColor? = nil) {
        self.customFontSize = fontSize
        self.customTextColor = textColor
        super.init(frame: .zero)
        self.style = style
        translatesAutoresizingMaskIntoConstraints = false
        applyStyle()
    }
    
    private func applyStyle() {
        let fontSize = customFontSize ?? defaultFontSize(for: style)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: style == .title ? .semibold : .regular)
        self.textColor = customTextColor ?? defaultTextColor(for: style)
    }
    
    private func defaultFontSize(for style: LabelStyle) -> CGFloat {
        switch style {
        case .title:
            return 14
        case .subtitle:
            return 12
        }
    }
    
    private func defaultTextColor(for style: LabelStyle) -> UIColor {
        switch style {
        case .title:
            return .black
        case .subtitle:
            return .gray
        }
    }
}
