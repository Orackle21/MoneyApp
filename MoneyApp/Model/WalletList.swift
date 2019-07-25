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
    private var selectedWalletIndex = 0
    
    
    private init(){
    }
    
    func addNewWallet(name: String, balance: Int, currency: Currency){
        let wallet = Wallet(name: name, balance: balance, currency: currency)
        wallet.calculateBalance()
        listOfAllWallets.append(wallet)
    }
    
    func moveWallet (from currentIndex: Int, to newIndex: Int) {
        let oldIndex = selectedWalletIndex
        let currentSelectedWallet = listOfAllWallets[oldIndex]
        
        let wallet = listOfAllWallets.remove(at: currentIndex)
        listOfAllWallets.insert(wallet, at: newIndex)
        
        let newIndex = listOfAllWallets.firstIndex(of: currentSelectedWallet)
        if oldIndex != newIndex {
            selectedWalletIndex = newIndex!
        }
    }
    
    func removeWallet (with index: Int) {
        if index == selectedWalletIndex {
            setSelectedWallet(index: 0)
        }
        listOfAllWallets.remove(at: index)
    }
    
    func getSelectedWallet() -> Wallet? {
        if listOfAllWallets.isEmpty {
          return nil
        } else {
       return listOfAllWallets[selectedWalletIndex]
        }
    }
    
    func setSelectedWallet(index: Int) {
        listOfAllWallets[selectedWalletIndex].isSelected = false
        selectedWalletIndex = index
        listOfAllWallets[index].isSelected = true
    }
    
}
