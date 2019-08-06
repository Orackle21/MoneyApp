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
   
    
    func prepareAlert(for indexPath: IndexPath) {
        actionSheet = UIAlertController(title: "Delete Category?", message: "Do you really want to delete this category?", preferredStyle: .actionSheet)
        actionSheet!.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in
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


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet.categoryList.listOfAllCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = wallet.categoryList.listOfAllCategories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategory = wallet.categoryList.listOfAllCategories[indexPath.row]
        return indexPath
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let category = wallet.categoryList.listOfAllCategories[indexPath.row]
        if category.canBeDeleted! {
            return true
        }
        return false
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

    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setCategory" {
            if let destination = segue.destination as? TransactionDetailViewController {
                destination.category = selectedCategory
            }
        }
    }
    */

}
