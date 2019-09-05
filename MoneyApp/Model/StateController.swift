//
//  WalletBox.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class StateController {
    
    var listOfAllWallets = [Wallet]()
    var dater: Dater
    private var selectedWalletIndex = 0
    
    init() {
        dater = Dater()
        addNewWallet(name: "Wallet"
            , balance: 500, currency: CurrencyList.shared.everyCurrencyList[1])
        setSelectedWallet(index: 0)
        addNewWallet(name: "Credit Card"
            , balance: 500, currency: CurrencyList.shared.everyCurrencyList[5])
        setSelectedWallet(index: 0)
    }
    
    func addNewWallet(name: String, balance: Decimal, currency: Currency){
        let wallet = Wallet(name: name, initialBalance: balance, currency: currency)
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
