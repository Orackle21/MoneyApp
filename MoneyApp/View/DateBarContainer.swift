//
//  DateBarContainer.swift
//  MoneyApp
//
//  Created by Orackle on 28.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class DateBarContainer: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 20.0
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.06975064214)
    }
    
    override func layoutSubviews() {
        
        if let _ = self.subviews.first as? UIVisualEffectView {
            return
        } else {
            var blurEffect: UIBlurEffect
            if #available(iOS 13.0, *) {
                blurEffect = UIBlurEffect(style: .systemThinMaterial)
            } else {
                blurEffect = UIBlurEffect(style: .extraLight)
            }
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.bounds
            
            self.insertSubview(blurView, at: 0)
            blurView.clipsToBounds = true
        }
        
        
    }

    
}
