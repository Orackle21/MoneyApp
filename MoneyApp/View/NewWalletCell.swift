//
//  NewWalletCell.swift
//  MoneyApp
//
//  Created by Orackle on 28.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//

import UIKit

class NewWalletCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            iconView.tintColor = UIColor.secondaryLabel
        } else {
 iconView.tintColor = UIColor.black        }
    }
}
