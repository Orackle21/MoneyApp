//
//  SkinChooserViewController.swift
//  MoneyApp
//
//  Created by Orackle on 11.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class ColorChooserViewController: UIViewController {

    private var colorPackNames = ["Standart Set", "Faded Set", "Vibrant Set"]
    private var colors = [String:[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getColorsFromJSON()
        print(colorPackNames)
        print(colors)
    }
    

    func getColorsFromJSON() {
        
        let decoder = JSONDecoder()
        let jsonFile = Bundle.main.url(forResource: "ui colors", withExtension: "json")
        
        var data = Data()
        do {
            data = try Data(contentsOf: jsonFile!)
        } catch {
            print("Error reading JSON")
        }
        
        var result: [String:[String]]
        result = try! decoder.decode([String:[String]].self, from: data)
        
        for (packName, colors) in result {
            self.colors.updateValue(colors, forKey: packName)

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
