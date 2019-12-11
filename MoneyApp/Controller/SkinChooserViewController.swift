//
//  SkinChooserViewController.swift
//  MoneyApp
//
//  Created by Orackle on 11.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class SkinChooserViewController: UIViewController {

    private var skinGroups = ["Misc", "Food", "Vehicles"]
    private var skins = [String:[Skin]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getSkinsFromJSON()
        print (skins)
    }
    

    func getSkinsFromJSON() {
        
        let decoder = JSONDecoder()
        let jsonFile = Bundle.main.url(forResource: "Skins", withExtension: "json")
        
        var data = Data()
        do {
            data = try Data(contentsOf: jsonFile!)
        } catch {
            print("Error reading JSON")
        }
        
        let result = try! decoder.decode([String: [Skin]].self, from: data)
        
        for (skinGroup, skinsArray) in result {
            
            skins.updateValue(skinsArray, forKey: skinGroup)
        }
        
        
        
    }

}


//extension SkinChooserViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
