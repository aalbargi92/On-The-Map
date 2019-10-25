//
//  UIButtonExtension.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func showLoading(_ loading: Bool) {
        if loading {
            
            let titleFrame = titleLabel!.frame
            let indicatorView = UIActivityIndicatorView(frame: .init(x: titleFrame.minX - 50, y: frame.height / 2 - (35 / 2), width: 35, height: 35))
            indicatorView.style = .medium
            indicatorView.color = .lightGray
            indicatorView.tag = 421
            
            addSubview(indicatorView)
            
            indicatorView.startAnimating()
            
            setTitleColor(.lightGray, for: .normal)
            
        } else {
            
            if let indicatorView = viewWithTag(421) {
                indicatorView.removeFromSuperview()
            }
            setTitleColor(.white, for: .normal)
        }
    }
}
