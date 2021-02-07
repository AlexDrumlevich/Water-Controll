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
    
    
    
    func becamePremiumAccaunt () {
        
        var needTocreateBanner = false
        
        accessController?.premiumAccount = !accessController!.premiumAccount
        
        if !accessController!.premiumAccount {
            if bannerView == nil {
                needTocreateBanner = true
                
            }
        } else {
            
            bannerView?.removeFromSuperview()
            bannerView = nil
        }
        
        
        if menuViewController == nil {
            self.viewDidLoadContinueLoading()
        } else {
            
            
            
            clouseSettingsViewController()
            
            DispatchQueue.main.async {
                
                if needTocreateBanner {
                    self.createBanner()
                    if self.menuViewController != nil {
                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.menuViewController.view)
                    }
                    if self.gameViewController != nil {
                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.gameViewController.view)
                    }
                    
                } else {
                if self.menuViewController != nil {
                    self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.menuViewController.view)
                }
                if self.gameViewController != nil {
                    self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.gameViewController.view)
                }
                }
                self.menuViewController.bottomMenuCollectionView.removeFromSuperview()
                self.menuViewController.bottomMenuCollectionView = BottomMenuCollectionView()
                self.presentBottomMenuActionsMenuViewControllerViaClosure()
                self.menuViewController.view.addSubview(self.menuViewController.bottomMenuCollectionView)
                self.menuViewController.setupBottomMenuCollectionView()
            
            }
            
           
            
        }
        
    }
    
    
}



