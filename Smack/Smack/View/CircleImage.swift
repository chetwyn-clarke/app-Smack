//
//  CircleImage.swift
//  Smack
//
//  Created by Chetwyn on 1/22/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

@IBDesignable class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    
    func setUpView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
