//
//  ParentCategoriesTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 22/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class ParentCategoriesTableViewController: UITableViewController {

    var wallet: Wallet?
    var categories: [Category]?
    var parentCategory: Category?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let wallet = wallet else {
            return
        }
        categories = wallet.categoryList.listOfAllCategories.filter ( {
            $0.isSubcategoryOf == nil
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return categories!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier:  "parentCategoryCell", for: indexPath)
            cell.textLabel?.text = "X - No Parent Category"
             return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parentCategoryCell", for: indexPath)

            cell.textLabel?.text = categories![indexPath.row].name
             return cell
        }

       
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            parentCategory = nil
        } else {
            parentCategory = categories![indexPath.row]
        }
        return indexPath
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
