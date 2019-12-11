//
//  CategoryDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 21/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UITableViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryIcon: UIView!
    @IBOutlet weak var subcategoryIcon: UIView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletIcon: UIView!
   
    var wallet: Wallet?
    var parentCategory: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let wallet = wallet else {
            return
        }
        walletNameLabel.text = wallet.name
        walletIcon.backgroundColor = wallet.color
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func saveCategory(_ sender: Any) {
        guard let wallet = wallet,
        let name = nameTextField.text
        else {
            return
        }
        wallet.categoryList.addNewCategory(name: name,
                                           skin: Skin(name: "dusk", color: "Dusk", icon: "coffee"),
                                           canBeDeleted: true, isSubcategoryOf: parentCategory ?? nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

   
    @IBAction func unwindToCategoryDetail(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? ParentCategoriesTableViewController {
            parentCategory = sourceViewController.subCategory
            subcategoryLabel.text = "Subcategory of: \(parentCategory?.name ?? "None")"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ParentCategoriesTableViewController {
            destination.wallet = wallet!
        }
    }
    

}
