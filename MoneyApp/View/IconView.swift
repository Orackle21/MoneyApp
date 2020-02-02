//
//  IconView.swift
//  MoneyApp
//
//  Created by Orackle on 05/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    var iconColors: [UIColor]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var iconName: String? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
     //   let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath(ovalIn: bounds)
  //      let color = categoryColor
        
        if let colors = iconColors {
            if colors.count == 1 {
                colors[0].setFill()
            }
        } else {
            #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setFill()
        }
        
        path.fill()
        
        
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
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
        } else {
            for view in self.subviews {
                view.removeFromSuperview()
            }
        }
        
        
    }
    
    
    func drawIcon(skin: Skin?) {
       
        if let skin = skin {
            iconName = skin.icon
            for color in skin.colors {
                let uiColor = color.colorFromHexOrName()
                iconColors = [uiColor]
            }
        } else {
            iconName = nil
        }
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
