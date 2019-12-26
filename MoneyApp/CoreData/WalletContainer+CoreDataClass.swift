//
//  WalletContainer+CoreDataClass.swift
//  MoneyApp
//
//  Created by Orackle on 24.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//
//

import Foundation
import CoreData

@objc(WalletContainer)
public class WalletContainer: NSManagedObject {

    func getSelectedWallet() -> Wallet? {
        var selectedWallet: Wallet?
        
        for nsObject in self.wallets! {
            let wallet = nsObject as! Wallet
            if wallet.isSelected {
                selectedWallet = wallet
            }
            
        }
        return selectedWallet
    }
    
    
    func setSelectedWallet (wallet: Wallet) {
        
        for nsObject in self.wallets! {
            let wallet = nsObject as! Wallet
            wallet.isSelected = false
        }
        wallet.isSelected = true
    }
}
