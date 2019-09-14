//
//  CategoryChooserViewController.swift
//  MoneyApp
//
//  Created by Orackle on 26/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class CategoryListViewController: UITableViewController {

    var selectedCategory: Category?
    var wallet: Wallet!
    var actionSheet: UIAlertController?
//    lazy var transactionsByCategory = categorizeTransactions(wallet: wallet!)
   
    
    func prepareAlert(for indexPath: IndexPath) {
        actionSheet = UIAlertController(title: "Delete Category?", message: "Do you really want to delete this category?", preferredStyle: .actionSheet)
        actionSheet!.addAction(UIAlertAction(
            title: "Delete Category And Associated Transactions",
            style: .destructive,
            handler: { _ in
                self.recategorizeTransactions(in: self.wallet, from: self.wallet.categoryList.listOfAllCategories[indexPath.row], to: self.wallet.categoryList.listOfAllCategories[indexPath.row])
                self.wallet.categoryList.removeCategory(with: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Category"
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func recategorizeTransactions (in wallet: Wallet, from: Category, to: Category) {
        let category = wallet.categoryList.listOfAllCategories[0]
        let transactions = wallet.allTransactionsGrouped.values
        var allTransactions = [Transaction]()
        for array in transactions {
            for item in array {
                allTransactions.append(item)
            }
        }
        allTransactions = allTransactions.filter {
            $0.category == from
        }
        let _ = allTransactions.map { $0.category = category
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet.categoryList.listOfAllCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if wallet.categoryList.listOfAllCategories[indexPath.row].isSubcategoryOf == nil {
            cell.textLabel?.text = wallet.categoryList.listOfAllCategories[indexPath.row].name
        } else {
            let name = wallet.categoryList.listOfAllCategories[indexPath.row].name
            cell.textLabel?.text = "↪️ \(name!)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategory = wallet.categoryList.listOfAllCategories[indexPath.row]
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let category = wallet.categoryList.listOfAllCategories[indexPath.row]
        if category.canBeDeleted! {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            prepareAlert(for: indexPath)
            self.present(actionSheet!, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        wallet.categoryList.moveCategory(from: fromIndexPath.row, to: to.row)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryDetailSegue" {
            if let destination = segue.destination as? CategoryDetailViewController {
                destination.wallet = wallet!
            }
        }
    }
    

}
