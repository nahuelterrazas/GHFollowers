//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 20/06/2023.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        placeholder = text
        configure()
    }

    
    private func configure(){
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor // always with layers
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go        
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
