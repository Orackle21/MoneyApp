//
//  TimePeriodViewController.swift
//  MoneyApp
//
//  Created by Orackle on 23.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//

import UIKit

protocol TimePeriodViewControllerDelegate: AnyObject {
    func didSelectDates(startDate: Date, endDate: Date)
}

class TimePeriodViewController: UITableViewController {
    
    weak var delegate: TimePeriodViewControllerDelegate?
    
    var startDate = Date()
    var endDate = Date()
    

    private let dateFormatter = DateFormatter()
    private var startIsCollapsed = true
    private var endIsCollapsed = true

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBAction func doneAction(_ sender: Any) {
        delegate?.didSelectDates(startDate: startDate, endDate: endDate)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startChanged(_ sender: UIDatePicker) {
        startDateLabel.text = dateFormatter.string(from: sender.date)
        startDate = sender.date
        switchDoneButton()
    }
    
    @IBAction func endChanged(_ sender: UIDatePicker) {
        endDateLabel.text = dateFormatter.string(from: sender.date)
        endDate = sender.date
        switchDoneButton()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        dateFormatter.dateFormat = "MMMM d, yyyy"
    }

    
    func switchDoneButton() {
        
        if startDate > endDate {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
           
            startIsCollapsed ? showDatePicker(datePicker: startDatePicker) : hideDatePicker(datePicker: startDatePicker)
        }
        if indexPath.section == 1 {
            endIsCollapsed ? showDatePicker(datePicker: endDatePicker) : hideDatePicker(datePicker: endDatePicker)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if startIsCollapsed {
                return 44
            } else if !startIsCollapsed{
                return 270
            }
        }
        
        if indexPath.section == 1 {
            if endIsCollapsed {
                return 44
            } else if !endIsCollapsed{
                return 270
            }
        }
        
        return 44
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

extension TimePeriodViewController {
    
    private func showDatePicker(datePicker: UIDatePicker) {
           
           tableView.beginUpdates()
           datePicker.isHidden = false
           datePicker.alpha = 0
           
           UIViewPropertyAnimator.runningPropertyAnimator(
               withDuration: 0.3,
               delay: 0,
               options: [.transitionCrossDissolve],
               animations: {
                   datePicker.alpha = 1
                if datePicker == self.startDatePicker {
                    self.startIsCollapsed = false
                } else {
                    self.endIsCollapsed = false
                }
                  
           }
           )
           tableView.endUpdates()
       }
       
       private func hideDatePicker (datePicker: UIDatePicker) {
           
           tableView.beginUpdates()
           UIViewPropertyAnimator.runningPropertyAnimator(
               withDuration: 0.3,
               delay: 0,
               options: [.transitionCrossDissolve],
               animations: {
                   datePicker.alpha = 0
                   if datePicker == self.startDatePicker {
                       self.startIsCollapsed = true
                   } else {
                       self.endIsCollapsed = true
                   }
                   
           }, completion:  {
               _ in
           }
           )
           tableView.endUpdates()
       }
    
    
}
