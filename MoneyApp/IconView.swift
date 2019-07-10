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
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: self.bounds)
        let gradient = CAGradientLayer()
        gradient.frame = path.bounds
        path.lineWidth = 0
        gradient.colors = categoryGradient
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
       
//        shapeMask.shadowOffset = .zero
//        shapeMask.shadowRadius = 5
//        shapeMask.shadowOpacity = 0.5
//        shapeMask.shadowPath = path.cgPath
        
        self.layer.addSublayer(gradient)
        
    }
    
    func setGradeintForCategory(category: Category) {
        if let gradient = category.iconGradients {
            categoryGradient = gradient
        }
        
    }

}
