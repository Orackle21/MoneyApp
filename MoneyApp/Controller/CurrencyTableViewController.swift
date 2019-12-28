//
//  CurrencyTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {

    var selectedCurrency: Currency?
    lazy var allCurrencies = CurrencyList.shared.allCurrencies
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCurrencies.count
    }

    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCurrency = allCurrencies[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        
        if let cell = cell as? CurrencyListCell {
            let currency = allCurrencies[indexPath.row]
            
            cell.nameLabel.text = currency.name
            cell.symbolLabel.text = currency.symbol ?? currency.id
            
        }
        return cell
    }

}
