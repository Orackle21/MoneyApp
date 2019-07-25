//
//  IconView.swift
//  MoneyApp
//
//  Created by Orackle on 05/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    var categoryGradient: [CGColor]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
       
        let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath(ovalIn: bounds)
        let colors = categoryGradient
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        path.addClip()
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors! as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        
        let image = UIImage(imageLiteralResourceName: "foodIcon")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: bounds.minX + 7 , y: bounds.minY + 7 , width: 26, height: 26)
        imageView.contentMode = UIView.ContentMode.scaleToFill
        self.addSubview(imageView)
        
    }
    
    
    func setGradeintForCategory(category: Category) {
        if let gradient = category.iconGradients {
            categoryGradient = gradient
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
    }
    
    
}

