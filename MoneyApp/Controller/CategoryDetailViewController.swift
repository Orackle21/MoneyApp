//
//  CategoryDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 21/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class CategoryDetailViewController: UITableViewController {

    var coreDataStack: CoreDataStack!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryIcon: UIView!
    @IBOutlet weak var subcategoryIcon: UIView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletIcon: UIView!
   
    
    
    var wallet: Wallet!
    var parentCategory: Category?
    var skin: Skin?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let wallet = wallet else {
            return
        }
        walletNameLabel.text = wallet.name
        if let categoryIcon = categoryIcon as? IconView,
            let subcategoryIcon = subcategoryIcon as? IconView,
            let walletIcon = walletIcon as? IconView {
            
            
            categoryIcon.drawIcon(skin: skin)
            categoryIcon.setNeedsDisplay()
            subcategoryIcon.drawIcon(skin: parentCategory?.skin)
            subcategoryIcon.setNeedsDisplay()
            walletIcon.drawIcon(skin: wallet.skin!)
            
        }
    }

    // MARK: - Table view data source

    @IBAction func saveCategory(_ sender: Any) {
        guard let wallet = wallet,
        let name = nameTextField.text
        else {
            return
        }
        // FIXME: Category creationq
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
            parentCategory = sourceViewController.selectedCategory
            subcategoryLabel.text = "Subcategory of: \(parentCategory?.name ?? "None")"
        }
    }
    
    
    @IBAction func unwindToCategoryDetailWithSkin(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let source = sourceViewController as? SkinChooserViewController {
            self.skin = source.selectedSkin
        }
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ParentCategoriesTableViewController {
            destination.wallet = wallet!
            destination.coreDataStack = coreDataStack
        }
    }
    

}
