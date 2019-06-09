//
//  TransactionsTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class TransactionsTableViewController: UITableViewController {
    
    var myWallet = Wallet()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transactionTest0 = Transaction(name: "Burger", subtitle: " ", amount: 55, category: .Food)
        let transactionTest1 = Transaction(name: "Internet", subtitle: " ", amount: 115, category: .Internet)
        let transactionTest2 = Transaction(name: "Electricity", subtitle: " ", amount: 125, category: .Utilities)
        
        myWallet.allTransactions.append(contentsOf: [transactionTest0, transactionTest1, transactionTest2])
   
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myWallet.allTransactions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath)
        
        let item = myWallet.allTransactions[indexPath.row]
        configureLabels(for: cell, with: item)
       

        return cell
    }
    
    func configureLabels(for cell: UITableViewCell, with item: Transaction) {
        if let transactionCell = cell as? TransactionTableViewCell {
            transactionCell.categoryLabel.text = item.category.rawValue
            transactionCell.nameLabel.text = item.name
            transactionCell.amountLabel.text = String(item.amount)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
