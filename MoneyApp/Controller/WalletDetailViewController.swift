//
//  WalletDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class WalletDetailViewController: UITableViewController {

    

    @IBOutlet weak var walletName: UITextField!
    @IBOutlet weak var walletBalance: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var walletCurrency: Currency?
    var coreDataStack: CoreDataStack!
    var walletContainer: WalletContainer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let wallet = Wallet(context: coreDataStack.managedContext)
        wallet.name = walletName.text
        wallet.isSelected = true
        wallet.amount = NSDecimalNumber(string: walletBalance.text ?? "0.0")
        wallet.currency = walletCurrency
        wallet.walletContainer = walletContainer
        wallet.skin = Skin(name: "", color: "Dusk", icon: "atm")
        
        let category = Category(context: coreDataStack.managedContext)
        category.wallet = wallet
        category.name = "Other"
        category.isDeletable = false
        category.skin = Skin(name: "other", color: "Field", icon: "atm")
        
        let initialBalance = Transaction(context: coreDataStack.managedContext)
        initialBalance.note = "Balance Update"
        initialBalance.amount = NSDecimalNumber(string: walletBalance.text)
        initialBalance.category = category
        initialBalance.currency = walletCurrency
        initialBalance.wallet = wallet
        initialBalance.date = Date()
        let components = initialBalance.date!.getComponenets()
        initialBalance.day = Int32(components.day!)
        initialBalance.month = Int32(components.month!)
        initialBalance.year = Int32(components.year!)
        
        walletContainer.setSelectedWallet(wallet: wallet)
        coreDataStack.saveContext()
        
        //FIXME: New wallet creation
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindToWalletDetail(_ unwindSegue: UIStoryboardSegue) {
        if let currencyList = unwindSegue.source as? CurrencyTableViewController {
            walletCurrency = currencyList.selectedCurrency
            currencyLabel.text = walletCurrency?.name
        }
    }
    
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
*/

}

