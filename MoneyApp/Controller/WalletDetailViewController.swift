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
