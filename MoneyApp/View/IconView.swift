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
        
        if let color = color {
            color.setFill()
        } else {
            #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setFill()
        }
        
        path.fill()
        
        
        self.layer.shadowOpacity = 0.17
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5.0
        
        
        
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
        
        if let iconName = iconName {
            let image = UIImage(named: iconName)
            let imageView = UIImageView(image: image)
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor.white
            imageView.frame = CGRect(x: bounds.minX , y: bounds.minY , width: (self.frame.width/2), height: (self.frame.height/2))
            imageView.center = CGPoint(x: self.frame.size.width  / 2,
                                       y: self.frame.size.height / 2)
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            
            for view in self.subviews {
                view.removeFromSuperview()
            }
            
            self.addSubview(imageView)
        }
        
        
    }
    
    
    func drawIcon(skin: Skin?) {
//       let gradient = category.iconGradients
//            categoryGradient = gradient
        if let skin = skin {
        categoryColor = UIColor(named: skin.color)
        iconName = skin.icon
           
        }
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
}
}
