//
//  GFButton.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 20/06/2023.
//

import UIKit

class GFButton: UIButton {
    override init(frame: CGRect) { // bc I'm making a custom
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { // no storyboard, no worries
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String){
        self.init(frame: .zero)
        self.configuration?.baseBackgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        configuration = UIButton.Configuration.filled()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.configuration?.baseBackgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    
}
