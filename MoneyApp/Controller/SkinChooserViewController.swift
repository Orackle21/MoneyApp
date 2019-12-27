//
//  SkinChooserViewController.swift
//  MoneyApp
//
//  Created by Orackle on 11.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class SkinChooserViewController: UIViewController {
    
    private var skinGroups = ["Transport", "Food"]
    private var skins = [String:[Skin]]()
    var selectedSkin: Skin?
    
    
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

extension SkinChooserViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return skinGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skins[skinGroups[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skinCollectionCell", for: indexPath)
        
        let skinArray = skins[skinGroups[indexPath.section]]
        let skin = skinArray![indexPath.row]
        
        if let cell = cell as? SkinCollectionViewCell {
            
            cell.iconView.drawIcon(skin: skin)
            cell.nameLabel.text = skin.name
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "skinHeader", for: indexPath) as? SkinHeaderView{
            sectionHeader.headerLabel.text = skinGroups[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let skinArray = skins[skinGroups[indexPath.section]]
        let skin = skinArray![indexPath.row]
        selectedSkin = skin
    }
    
}
    
    
    
    
extension SkinChooserViewController: UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        let width  = (view.frame.width-20)/4
        return CGSize(width: width, height: width)
    }

}


