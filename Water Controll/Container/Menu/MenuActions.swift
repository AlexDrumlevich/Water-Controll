//
//  MenuActions.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 09.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension MenuViewController {
    
    //save context
    func saveContextInDataBase() {
        guard let containerViewController = self.parent as? ContainerViewController  else {
            print("can`t get ContainerViewController in  MenuViewController")
            return
        }
        containerViewController.saveContextInLocalDataBase()
    }
    

    
    func getOneMoreBottle() {
        
        print("You got one more bottle")
        
    }
    
    func becomePremiumAccountFromMenuViewController() {
        
        if let containerVC = self.parent as? ContainerViewController {
            containerVC.becamePremiumAccaunt()
        } else {
           // getOneMoreBottleAdCustomAlertController()
            print("error")
        }
       // print("You get premium account")
             
    }
    
    
    
    @objc func changeUserNext() {
        (self.parent as? ContainerViewController)?.changeUser(direction: .next)
        if pourWaterMenu != nil {
            deletePourWaterMenu()
            showPourWaterMenu()
            
        }
        
    }
    
    @objc func changeUserPrevious() {
        (self.parent as? ContainerViewController)?.changeUser(direction: .previous)
        if pourWaterMenu != nil {
            deletePourWaterMenu()
            showPourWaterMenu()
            
        }
    }
    
    
    
    
}
