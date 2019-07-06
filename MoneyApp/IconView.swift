//
//  IconView.swift
//  MoneyApp
//
//  Created by Orackle on 05/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class IconView: UIView {

    var categoryGradient: [CGColor]?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: self.bounds)
        let gradient = CAGradientLayer()
        gradient.frame = path.bounds
        
        gradient.colors = categoryGradient
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
        
    }
    
    func setGradeintForCategory(category: Category) {
        if let gradient = category.iconGradients {
            categoryGradient = gradient
        }
        
    }

}
