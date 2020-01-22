//
//  AppDelegate.swift
//  MoneyApp
//
//  Created by Orackle on 09/05/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let coreDataStack = CoreDataStack(modelName: "AppData")
    private var fetchRequest: NSFetchRequest<WalletContainer>?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        if #available(iOS 13.0, *) {
//            self.window?.backgroundColor = UIColor.systemBackground
//        } else {
//           self.window?.backgroundColor = UIColor.white
//
//        }

        var walletContainer: WalletContainer!
        fetchRequest = WalletContainer.fetchRequest()
        do {
            let walletContainers = try coreDataStack.managedContext.fetch(fetchRequest!)
            if walletContainers.count > 0 {
                walletContainer = walletContainers[0]
            }
            else {
                walletContainer = WalletContainer(context: coreDataStack.managedContext)
                walletContainer.wallets = NSOrderedSet()
                coreDataStack.saveContext()
            }
        } catch let error as NSError {
            print (error)
        }
        
        // Dependency Injection of "CoreDataStack" and "WalletContainer" into all tabs
        
        if let tabController = window?.rootViewController as? UITabBarController {
           
            if let navigationController = tabController.viewControllers![0] as? UINavigationController {
                if  let initialViewController = navigationController.viewControllers.first as? ReportsViewController {
                    initialViewController.coreDataStack = coreDataStack
                    initialViewController.walletContainer = walletContainer
                }
            }
            
            if let navigationController = tabController.viewControllers![1] as? UINavigationController {
                if  let initialViewController = navigationController.viewControllers.first as? TransactionsViewController {
                    initialViewController.coreDataStack = coreDataStack
                    initialViewController.walletContainer = walletContainer
                }
            }
            
            
            if let navigationController = tabController.viewControllers![2] as? UINavigationController {
                if  let initialViewController = navigationController.viewControllers.first as? BudgetViewController {
                    initialViewController.coreDataStack = coreDataStack
                    initialViewController.walletContainer = walletContainer
                }
            }
            
            
        }
        
        
      
        
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

