//
//  TabBarViewController.swift
//  MoneyApp
//
//  Created by Orackle on 05/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

protocol CustomTabBarControllerDelegate{
    func customTabBarControllerDelegate_CenterButtonTapped(tabBarController:CustomTabBarController, button:UIButton, buttonState:Bool);
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var customTabBarControllerDelegate:CustomTabBarControllerDelegate?
    var centerButton: UIButton!
    private var centerButtonTappedOnce: Bool = false
    
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews();
        
        self.bringcenterButtonToFront();
         centerButton.frame.origin.y = self.view.bounds.height - centerButton.frame.height - self.view.safeAreaInsets.bottom
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.selectedIndex = 1
        self.delegate = self;
        self.viewControllers![1].title = " "
        self.setupMiddleButton()
    }
    
    
    // MARK: - TabbarDelegate Methods
    
   func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        switch viewController
        {
        case is ReportsViewController:
            self.hideCenterButton()
            self.viewControllers![1].title = "Transactions"
        case is BudgetViewController:
            self.hideCenterButton()
            self.viewControllers![1].title = "Transactions"
        default:
            self.showCenterButton()
            self.viewControllers![1].title = " "
        }
    }
    
    // MARK: - Internal Methods
    
    @objc private func centerButtonAction(sender: UIButton){
        customTabBarControllerDelegate?.customTabBarControllerDelegate_CenterButtonTapped(tabBarController: self,
                                                                                          button: centerButton,
                                                                                          buttonState: centerButtonTappedOnce);
    }
    
   private func hideCenterButton(){
        centerButton.isHidden = true;
    }
    
    private func showCenterButton(){
        centerButton.isHidden = false;
        self.bringcenterButtonToFront();
    }
    
    // MARK: - Private methods
    
    private func setupMiddleButton() {
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        
        var centerButtonFrame = centerButton.frame
        centerButtonFrame.origin.y = view.bounds.height - centerButtonFrame.height - view.safeAreaInsets.bottom
        print( centerButtonFrame.origin.y)
        centerButtonFrame.origin.x = view.bounds.width/2 - centerButtonFrame.size.width/2
        centerButton.frame = centerButtonFrame
        
        centerButton.backgroundColor = #colorLiteral(red: 0.5739042749, green: 0.4383537778, blue: 1, alpha: 1)
        centerButton.layer.cornerRadius = centerButtonFrame.height/2
        view.addSubview(centerButton)
        
        let icon = UIImage(named: "addButton")
        centerButton.setImage(icon?.maskWithColor(color: UIColor.white), for: .normal)
      
        centerButton.addTarget(self, action: #selector(centerButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    private func bringcenterButtonToFront()
    {
        print("bringcenterButtonToFront called...")
        self.view.bringSubviewToFront(self.centerButton);
    }

}
