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
            self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.clear
        }
    }
}
