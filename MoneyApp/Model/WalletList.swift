//
//  WalletBox.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class WalletList{
    static let list = WalletList()
    var listOfAllWallets = [Wallet]()
    
    //Initializer access level change now
    private init(){}
    
    func addNewWallet(name: String, balance: Int, currency: Currency){
        let wallet = Wallet(name: name, balance: balance, currency: currency)
        listOfAllWallets.append(wallet)
    }
    
}
