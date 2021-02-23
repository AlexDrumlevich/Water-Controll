//
//  PourWaterIntoBottle.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 16.08.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation

extension MenuViewController {
    
    func pourWaterIntoBottleIsNotEmptyBottle() {
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let textFillTheIsNotEmptyBottle = AppTexts.textFillTheIsNotEmptyBottle
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .fillTheIsNotEmptyBottle, view: view, text: textFillTheIsNotEmptyBottle, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "pourWaterIntoBottle", thirdButtonText: nil, imageInButtons: true)
        
    }
    
    
    func pourWaterIntoBottle(with access: AccessController?) {
        
        
        //pour water depend of access
        //access isn`t nil
        if self.accessController != nil {
            //premium or bottle is available
            if self.accessController!.premiumAccount || self.accessController!.bottelsAvailable > 0  {
                self.currentUser.isEmptyBottle = false
                self.currentUser.currentVolumeInBottle = self.currentUser.fullVolume
                gameSceneController?.isChangeWaterLevelFromPourWaterInBottle = true
                gameSceneController?.currentWaterLevel = 1
                if !self.accessController!.premiumAccount {
                    self.accessController!.bottelsAvailable -= 1
                    if countLabelAvailableBottlesInCell != nil {
                        DispatchQueue.main.async {
                            self.countLabelAvailableBottlesInCell?.text = String(self.accessController!.bottelsAvailable)
                        }
                    }
                }
                //save context
                saveContextInDataBase()
                
                //bottle isn`t available
            } else {
                noBottlesWithWaterAlertController()
            }
            //access is nil
        } else {
            self.currentUser.isEmptyBottle = false
            self.currentUser.currentVolumeInBottle = self.currentUser.fullVolume
            gameSceneController?.isChangeWaterLevelFromPourWaterInBottle = true
            gameSceneController!.currentWaterLevel = 1
        }
        print(self.accessController!.bottelsAvailable, self.accessController!.premiumAccount)
    }
    
    //alert no bottles
    func noBottlesWithWaterAlertController() {
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let textNoAvailableBottlesWithWater = AppTexts.textNoAvailableBottlesWithWater
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .noBottlesWithWater, view: view, text: textNoAvailableBottlesWithWater, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "getOneMoreBottle", thirdButtonText: "unlimitedBottels", imageInButtons: true)
        
    }
    // auto fill system
    //we call this method from ContainerViewControllerEmptyBottleInDayBeginning and when users change - did set method in menu view controller 
    func fillBottleAutoFillUserType() {
        guard currentUser != nil else { return }
        if currentUser.isAutoFillBottleType && currentUser.isEmptyBottle {
            pourWaterIntoBottle(with: accessController)
        }
    }
    
    
}




