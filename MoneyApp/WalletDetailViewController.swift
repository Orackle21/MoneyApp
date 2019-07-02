//
//  WalletDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class WalletDetailViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBOutlet weak var walletName: UITextField!
    @IBOutlet weak var walletBalance: UITextField!
    var walletCurrency: Currency?
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        guard let name = walletName.text,
            let balance = Int (walletBalance.text ?? "0"),
            let currency = walletCurrency else {
                return
        }
        
        WalletList.list.addNewWallet(name: name, balance: balance, currency: currency)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindToWalletDetail(_ unwindSegue: UIStoryboardSegue) {
        if let currencyList = unwindSegue.source as? CurrencyTableViewController {
            walletCurrency = currencyList.selectedCurrency
            currencyLabel.text = walletCurrency?.currencyName
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
*/

}
