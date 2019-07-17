//
//  WalletBox.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class WalletList{
    static let shared = WalletList()
    var listOfAllWallets = [Wallet]()
    var selectedWalletIndex = 0
    
    
    private init(){}
    
    func addNewWallet(name: String, balance: Int, currency: Currency){
        let wallet = Wallet(name: name, balance: balance, currency: currency)
        wallet.calculateBalance()
        listOfAllWallets.append(wallet)
    }
    
    func removeWallet (with index: Int) {
        listOfAllWallets.remove(at: index)
        print (listOfAllWallets.count)
    }
    
    func moveWallet (from currentIndex: Int, to newIndex: Int) {
        let wallet = listOfAllWallets.remove(at: currentIndex)
        listOfAllWallets.insert(wallet, at: newIndex)
    }
    
    func getSelectedWallet() -> Wallet? {
        if listOfAllWallets.isEmpty {
          return nil
        } else {
       return listOfAllWallets[selectedWalletIndex]
        }
    }
    
}
