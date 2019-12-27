//
//  CategoryDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 21/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryDetailViewControllerDelegate: AnyObject {
    func didCreateNewCategory()
}

class CategoryDetailViewController: UITableViewController {
    
    weak var delegate: CategoryDetailViewControllerDelegate?
    var coreDataStack: CoreDataStack!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryIcon: UIView!
    @IBOutlet weak var parentCategoryIcon: UIView!
    @IBOutlet weak var parentCategoryLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletIcon: UIView!
   
    
    
    var wallet: Wallet!
    var parentCategory: Category? {
        didSet {
            parentCategoryIcon.setNeedsDisplay()
        }
    }
    var skin: Skin? {
        didSet {
            parentCategoryIcon.setNeedsDisplay()
        }
    }
    
    
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
            let subcategoryIcon = parentCategoryIcon as? IconView,
            let walletIcon = walletIcon as? IconView {
            
            
            categoryIcon.drawIcon(skin: skin)
            categoryIcon.setNeedsDisplay()
            subcategoryIcon.drawIcon(skin: parentCategory?.skin)
            walletIcon.drawIcon(skin: wallet.skin!)
            
        }
    }

    // MARK: - Table view data source

    @IBAction func saveCategory(_ sender: Any) {
        guard let wallet = wallet,
        let name = nameTextField.text else { return }
        
        if let parentCategory = parentCategory {
            let category = SubCategory(context: coreDataStack.managedContext)
            category.name = name
            category.wallet = wallet
            category.skin = skin
            category.parentCategory = parentCategory
            
        } else {
            let category = Category(context: coreDataStack.managedContext)
            category.name = name
            category.wallet = wallet
            category.skin = skin
        }
        
        coreDataStack.saveContext()
        delegate?.didCreateNewCategory()
        navigationController?.popViewController(animated: true)
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
            parentCategoryLabel.text = "Subcategory of: \(parentCategory?.name ?? "None")"
            
            // resets the icon if parent category in unchecked
            if parentCategory == nil, let parentCategoryIcon = parentCategoryIcon as? IconView {
                parentCategoryIcon.drawIcon(skin: Skin(name: "", color: "", icon: ""))
                
            }
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
            destination.wallet = wallet
            destination.coreDataStack = coreDataStack
        }
    }
    

}
