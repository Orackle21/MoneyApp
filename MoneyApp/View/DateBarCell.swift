//
//  CollectionViewCell.swift
//  MoneyApp
//
//  Created by Orackle on 18/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class DateBarCell: UICollectionViewCell {
    
    @IBOutlet weak var monthName: UILabel!

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.contentView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.65)
                monthName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                self.contentView.backgroundColor = UIColor.clear
                monthName.textColor = UIColor.systemGray
            }
            
        }
    }
}
