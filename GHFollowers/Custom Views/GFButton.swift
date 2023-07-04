//
//  GFButton.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 20/06/2023.
//

import UIKit

var configurationButton = UIButton.Configuration.filled()

class GFButton: UIButton {
    override init(frame: CGRect) { // bc I'm making a custom
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { // no storyboard, no worries
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String){
        super.init(frame: .zero) // later
        configurationButton.baseBackgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        configuration = configurationButton
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
}
