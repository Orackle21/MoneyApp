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
    let colors: [String]
    let icon: String
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(colors, forKey: "colors")
        coder.encode(icon, forKey: "icon")
        
    }
    
    public convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let colors = coder.decodeObject(forKey: "colors") as! [String]
        let icon = coder.decodeObject(forKey: "icon") as! String
        
        self.init(name: name, colors: colors, icon: icon)
    }
    
    
    init(name: String, colors: [String], icon: String) {
        self.name = name
        self.colors = colors
        self.icon = icon
    }
}
