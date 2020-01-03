//
//  subCategoryCell.swift
//  MoneyApp
//
//  Created by Orackle on 03.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//

import UIKit

class subCategoryCell: UITableViewCell {

    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func customize(skin: Skin, name: String) {
        
        iconView.drawIcon(skin: skin)
        nameLabel.text = name
        
    }
}
