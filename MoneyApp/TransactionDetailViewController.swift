//
//  AddTransactionTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 10/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

protocol TransactionDetailViewControllerDelegate: class {
    
    func transactionDetailViewControllerDidCancel(_ controller: TransactionDetailViewController)
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishAdding item: Transaction)
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishEditing item: Transaction)
    
}

class TransactionDetailViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    weak var delegate: TransactionDetailViewControllerDelegate?
    var transactionToEdit: Transaction?
    var wallet: Wallet?
    
    @IBAction func saveAction(_ sender: Any) {
        if let _ = transactionToEdit {
            ///
        }
        else {
            if let wallet = wallet {
                let transaction = wallet.newTransaction(in: .Food, name: nameTextField.text!, subtitle: subtitleTextField.text!, amount: Int(amountTextField.text!)!)
                delegate?.transactionDetailViewController(self, didFinishAdding: transaction)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
