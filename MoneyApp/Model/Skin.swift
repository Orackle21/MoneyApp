//
//  Skin.swift
//  MoneyApp
//
//  Created by Orackle on 09.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

@objc public final class Skin: NSObject, NSCoding, Codable {
    
    let name: String
    let color: String
    let icon: String
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(color, forKey: "color")
        coder.encode(icon, forKey: "icon")
        
    }
    
    public convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let color = coder.decodeObject(forKey: "color") as! String
        let icon = coder.decodeObject(forKey: "icon") as! String
        
        self.init(name: name, color: color, icon: icon)
    }
    
    
    init(name: String, color: String, icon: String) {
        self.name = name
        self.color = color
        self.icon = icon
    }
}
