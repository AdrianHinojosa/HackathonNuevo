//
//  RoundButton.swift
//  carpoolApp
//
//  Created by Fernando Carrillo on 8/26/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
@IBDesignable

class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            
        }
        
    }
    
}
