//
//  ContainerViewControllerBecamePremiumAccaunt.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 01.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

// purchase and create premium account
extension ContainerViewController {
    
    
    func sratrPurchasing(needToRestoreOnly: Bool = false) {
        
        purchaseController = PurchaseController(containerVC: self, needToRestoreOnly: needToRestoreOnly)
        
    }
    
    
    
    func clousePurchaseController() {
        purchaseController?.removeNotificationObserver()
        purchaseController = nil
        
    }
    
    
    
    func becamePremiumAccaunt() {
        
        //   var needTocreateBanner = false
        
        // accessController?.premiumAccount = !accessController!.premiumAccount
        
        //        if !accessController!.premiumAccount {
        //            if bannerView == nil {
        //                needTocreateBanner = true
        //
        //            }
        //        } else {
        //
        //            bannerView?.removeFromSuperview()
        //            bannerView = nil
        //        }
        
        if bannerView != nil {
            DispatchQueue.main.async {
                self.bannerView?.removeFromSuperview()
                self.bannerView = nil
            }
        }
        accessController?.premiumAccount = true
        saveContextInLocalDataBase()
        
        setConstraintsWhenChangeHappens()
    }
    
}





