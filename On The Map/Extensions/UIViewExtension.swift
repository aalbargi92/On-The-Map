//
//  UIViewExtension.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
