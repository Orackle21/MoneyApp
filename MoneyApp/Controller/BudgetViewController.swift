//
//  BudgetViewController.swift
//  MoneyApp
//
//  Created by Orackle on 05/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    var walletContainer: WalletContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "budgetDetail" {
            if let navigationController = segue.destination as? UINavigationController {
                if let destination = navigationController.viewControllers.first as? BudgetDetailViewController {
                    destination.coreDataStack = coreDataStack
                    destination.wallet = walletContainer.getSelectedWallet()
                }
                
            }
        }
    }
    
    
}
