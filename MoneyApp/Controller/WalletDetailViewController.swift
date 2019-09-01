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
    @IBOutlet weak var currencyLabel: UILabel!
    
    var walletCurrency: Currency?
    var stateController: StateController!
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        guard let name = walletName.text,
            let balance = Decimal (string: walletBalance.text ?? "0"),
              let currency = walletCurrency else {
                  return
              }
        
        stateController.addNewWallet(name: name, balance: balance, currency: currency)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindToWalletDetail(_ unwindSegue: UIStoryboardSegue) {
        if let currencyList = unwindSegue.source as? CurrencyTableViewController {
            walletCurrency = currencyList.selectedCurrency
            currencyLabel.text = walletCurrency?.currencyName
        }
    }
    
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
*/

}
