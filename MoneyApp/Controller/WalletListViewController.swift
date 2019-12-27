//
//  WalletListViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class WalletListViewController: UITableViewController {
    
    
    var coreDataStack: CoreDataStack!
    var walletContainer: WalletContainer?
    var wallets = NSOrderedSet()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wallets = walletContainer!.wallets {
            self.wallets =  wallets
        }
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath)
        
        if let cell = cell as? WalletCell, let wallet = wallets[indexPath.row] as? Wallet {
            cell.textLabel?.text = wallet.name
            cell.walletAmountLabel.text = wallet.amount?.description
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        //FIXME: Selected wallet choosing
        
        return indexPath
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //FIXME: Implement deletion
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    // Override to support rearranging the table view.
    //    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    //       stateController.moveWallet(from: fromIndexPath.row, to: to.row)
    //    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WalletDetailViewController {
            destination.coreDataStack = coreDataStack
            destination.walletContainer = walletContainer!
            destination.delegate = self
        }
    }
    
    
    
}

extension WalletListViewController: WalletDetailViewControllerDelegate {
    func didAddNewWallet() {
        tableView.reloadData()
    }
    
    
}
