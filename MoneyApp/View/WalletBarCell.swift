//
//  WalletBarViewCell.swift
//  MoneyApp
//
//  Created by Orackle on 17/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class WalletBarCell: UICollectionViewCell {
    
    
    @IBOutlet weak var walletName: UILabel!
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.20
        layer.masksToBounds = false
    }
    
   func configureWalletBarItems (with item: Wallet) {
    if item.isSelected {
        if let skin = item.skin {
            if let color = UIColor(named: skin.colors[0]) {
                self.backgroundColor = color
            } else {
                let color = UIColor(hexFromString: skin.colors[0])
                self.backgroundColor = color
            }
        }
        
    } else {
        self.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.4013805651)
    }

   }
}
