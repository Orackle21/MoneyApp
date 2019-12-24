//
//  Currency.swift
//  MoneyApp
//
//  Created by Orackle on 27/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

@objc public final class Currency: NSObject, NSCoding {
    static func < (lhs: Currency, rhs: Currency) -> Bool {
        if lhs.name < rhs.name {
            return true
        }
        else {
            return false }
    }
    
    var name: String
    var symbol :String?
    var id: String
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(symbol, forKey: "symbol")
        coder.encode(id, forKey: "id")
        
    }
    
    public convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let symbol = coder.decodeObject(forKey: "symbol") as! String
        let id = coder.decodeObject(forKey: "id") as! String
        
        self.init(name: name, symbol: symbol, id: id)
    }
    
    
    init(name: String, symbol: String?, id: String) {
        self.name = name
        self.symbol = symbol
        self.id = id
    }
    
}

class CurrencyList {
    
    static var shared = CurrencyList()
    lazy var allCurrencies = loadEveryCurrency()
    
    func loadEveryCurrency() -> [Currency] {
        var currencies = [Currency]()
        let decoder = JSONDecoder()
        let jsonFile = Bundle.main.url(forResource: "currencies", withExtension: "json")
        
        var data = Data()
        do {
            data = try Data(contentsOf: jsonFile!)
        } catch {
            print("whoops")
        }
        
        
        var result: [String:[String:[String:String]]]
        result = try! decoder.decode([String : [String : [String : String]]].self, from: data)
        
        //unwrap that crazy json response in 1 loop. It looks crazy but it works
        
        for (_, value) in result {
            for (_, value) in value {
                
                var name: String?
                var symbol: String?
                var id: String?
                
                for (key, value) in value {
                    switch key {
                    case "currencyName": name = value
                    case "currencySymbol": symbol = value
                    case "id": id = value
                    default:
                        break
                    }
                }
                currencies.append(Currency(name: name!, symbol: symbol, id: id!))
            }
        }
        currencies = currencies.sorted(by: <)
        return currencies
        
    }
    
}
