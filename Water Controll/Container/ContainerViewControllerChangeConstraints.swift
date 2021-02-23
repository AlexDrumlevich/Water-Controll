//
//  ContainerViewControllerChangeConstraints.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.02.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation


extension ContainerViewController {
    
    func setConstraintsWhenChangeHappens() {
        if menuViewController == nil {
            DispatchQueue.main.async {
                self.viewDidLoadContinueLoading()
            }
        } else {
            clouseSettingsViewController()
            DispatchQueue.main.async {
                //
                //                if needTocreateBanner {
                //                    self.createBanner()
                //                    if self.menuViewController != nil {
                //                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.menuViewController.view)
                //                    }
                //                    if self.gameViewController != nil {
                //                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.gameViewController.view)
                //                    }
                //
                //                }
                //                else {
                //                if self.menuViewController != nil {
                
                self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.menuViewController.view)
            }
            if self.gameViewController != nil {
                DispatchQueue.main.async {
                    self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.gameViewController.view)
                }
            }
        }
        
        //remove bottom collection view
        DispatchQueue.main.async {
            self.menuViewController.bottomMenuCollectionView?.removeFromSuperview()
            //create new bottom collection view
            self.menuViewController.bottomMenuCollectionView = BottomMenuCollectionView(isVertical: self.viewWidth >= self.viewHeight)
            self.presentBottomMenuActionsMenuViewControllerViaClosure()
            self.menuViewController.view.addSubview(self.menuViewController.bottomMenuCollectionView!)
            self.menuViewController.setupBottomMenuCollectionView()
        }
    }
}
