//
//  WalletDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

protocol WalletDetailViewControllerDelegate: AnyObject {
    func didAddNewWallet()
}

class WalletDetailViewController: UITableViewController {

    weak var delegate: WalletDetailViewControllerDelegate?
    
    @IBOutlet weak var walletName: UITextField!
    @IBOutlet weak var walletBalance: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coreDataStack: CoreDataStack!
    var walletContainer: WalletContainer!
    
    private var walletCurrency: Currency?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIColor.white

    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let today = Date()
        
        let wallet = Wallet(context: coreDataStack.managedContext)
        wallet.name = walletName.text
        wallet.isSelected = true
        wallet.amount = NSDecimalNumber(string: walletBalance.text ?? "0.0")
        wallet.currency = walletCurrency
        wallet.walletContainer = walletContainer
        wallet.skin = Skin(name: "", colors: ["Dusk"], icon: "")
        wallet.dateCreated = today
        
        let category = Category(context: coreDataStack.managedContext)
        category.wallet = wallet
        category.name = "Other"
        category.isDeletable = false
        category.skin = Skin(name: "other", colors: ["Field"], icon: "atm")
        
        let category2 = SubCategory(context: coreDataStack.managedContext)
        category2.wallet = wallet
        category2.name = "Sub of Other"
        category2.parentCategory = category
        category2.skin = Skin(name: "other", colors: ["#f093fb", "#f5576c"], icon: "taxi")
        
        
        let initialBalance = Transaction(context: coreDataStack.managedContext)
        initialBalance.note = "Balance Update"
        initialBalance.amount = NSDecimalNumber(string: walletBalance.text)
        initialBalance.category = category
        initialBalance.currency = walletCurrency
        initialBalance.wallet = wallet
        initialBalance.month = Int64(today.month()!)
        initialBalance.year = Int64(today.year()!)
        initialBalance.simpleDate = Int64(today.getSimpleDescr())
        initialBalance.dateCreated = today
        
        
        walletContainer.setSelectedWallet(wallet: wallet)
        coreDataStack.saveContext()
        delegate?.didAddNewWallet()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindToWalletDetail(_ unwindSegue: UIStoryboardSegue) {
        if let currencyList = unwindSegue.source as? CurrencyTableViewController {
            walletCurrency = currencyList.selectedCurrency
            currencyLabel.text = walletCurrency?.name
        }
    }
    


}

