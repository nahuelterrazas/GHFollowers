//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 20/06/2023.
//

import UIKit

class GFTitleLabel: UILabel {
    
    override init(frame: CGRect) { // bc I'm making a custom
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAligment: NSTextAlignment, fontSize: CGFloat){
        super.init(frame: .zero)
        self.textAlignment = textAligment
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }

    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
