//
//  Skin.swift
//  MoneyApp
//
//  Created by Orackle on 09.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

struct Skin: Codable {
    
    let name: String
    var color: String
    var icon: String
    
    
    init(name: String, color: String, icon: String) {
        self.name = name
        self.color = color
        self.icon = icon
    }
}
