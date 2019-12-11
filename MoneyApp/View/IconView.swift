//
//  IconView.swift
//  MoneyApp
//
//  Created by Orackle on 05/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class IconView: UIView {
    
//    var categoryGradient: [CGColor]?
    var categoryColor: UIColor?
    var iconName: String?
    
    override func draw(_ rect: CGRect) {
       
//        let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath(ovalIn: bounds)
        let color = categoryColor
        
        
        color!.setFill()
        path.fill()
        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//        path.addClip()
//        let gradient = CGGradient(colorsSpace: colorSpace,
//                                  colors: colors! as CFArray,
//                                  locations: colorLocations)!
//
//        let startPoint = CGPoint.zero
//        let endPoint = CGPoint(x: 0, y: bounds.height)
//        context.drawLinearGradient(gradient,
//                                   start: startPoint,
//                                   end: endPoint,
//                                   options: [])
        
//         adding an icon
        let image = UIImage(named: iconName!)
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.frame = CGRect(x: bounds.minX , y: bounds.minY , width: (self.frame.width/2), height: (self.frame.height/2))
        imageView.center = CGPoint(x: self.frame.size.width  / 2,
        y: self.frame.size.height / 2)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        if self.subviews.isEmpty {
            self.addSubview(imageView)
        }   
    }
    
    
    func setGradientForCategory(category: Category) {
//       let gradient = category.iconGradients
//            categoryGradient = gradient
        categoryColor = UIColor(named: category.skin.color)
        iconName = category.skin.icon
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
}

