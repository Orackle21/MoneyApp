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
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    private var datePickerIsCollapsed = true

    
    weak var delegate: TransactionDetailViewControllerDelegate?
    var transactionToEdit: Transaction?
    var wallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = transactionToEdit {
            nameTextField.text = item.name
            amountTextField.text = String(item.amount)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            if datePickerIsCollapsed {
                datePickerIsCollapsed = false
            } else {
                datePickerIsCollapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            if datePickerIsCollapsed {
                return 0
            } else if datePickerIsCollapsed == false {
                return 216
            }
        }
        return 44
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        if let item = transactionToEdit {
            item.name = nameTextField.text ?? " "
            item.amount = Int(amountTextField.text ?? "0") ?? 0
            delegate?.transactionDetailViewController(self, didFinishEditing: item)
        }
        else {
            if let wallet = wallet {
                let transaction = wallet.newTransaction(in: .Food, name: nameTextField.text!, amount: Int(amountTextField.text!)!)
                delegate?.transactionDetailViewController(self, didFinishAdding: transaction)
            }
        }
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
