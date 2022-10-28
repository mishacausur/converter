//
//  Button.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UIButton

final class Button: UIButton {
    
    enum Font {
        case regular
        case small
    }
    
    var cornerRadius: CGFloat = 12
    var color: UIColor = Color.mainOrage
    var font: Font {
        didSet {
            switch font {
            case .regular:
                titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            case .small:
                titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            }
        }
    }
  
    override init(frame: CGRect) {
        font = .regular
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, font: Font) {
        self.font = font
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        backgroundColor = color
        setTitle(title, for: .normal)
    }
}

