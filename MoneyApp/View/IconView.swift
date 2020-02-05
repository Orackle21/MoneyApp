//
//  IconView.swift
//  MoneyApp
//
//  Created by Orackle on 05/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class IconView: UIView {

    private var iconColors: [UIColor]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var iconName: String? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath(ovalIn: bounds)
        
        
        // If there's only one color - fill path with the color, if there are 2 colors - draw gradient, else - fill with grey color.
        
        if let colors = iconColors {
            if colors.count == 1 {
                colors[0].setFill()
                path.fill()
            }
            else if colors.count == 2 {
                drawGradient(path: path, context: context)
            }
        } else {
            #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setFill()
            path.fill()
        }
        
        
        
        // Add shadow to the rounded path
        
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5.0
        

        // Add an icon as a subview, if there is already an icon present - do nothing
        
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
    
    
    private func drawGradient(path: UIBezierPath, context: CGContext) {
        var colors = [CGColor]()
        if let uiColors = iconColors {
            colors = convertToCGColors(colors: uiColors)
        }
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        path.addClip()
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
    
    private func convertToCGColors(colors: [UIColor]) -> [CGColor] {
        var cgColors = [CGColor]()
        if let uiColors = iconColors {
            for color in uiColors {
                cgColors.append(color.cgColor)
            }
        }
        
        return cgColors
    }
    
    func drawIcon(skin: Skin?) {
       
        if let skin = skin {
            iconName = skin.icon
            iconColors = [UIColor]()
            for color in skin.colors {
                let uiColor = color.colorFromHexOrName()
                iconColors?.append(uiColor)
            }
        } else {
            iconName = nil
        }
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func drawIcon(color: UIColor, iconName: String) {
        
        iconColors = [color]        
        self.iconName = iconName
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
