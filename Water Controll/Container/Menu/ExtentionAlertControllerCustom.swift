//
//  ExtentionAlertControllerCustom.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 11.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation
//Alert Custom extension

extension MenuViewController: AlertControllerCustomActions {
    func buttonPressed(indexOfPressedButton: Int, identifire: AlertIdentifiers) {
      
        
        switch indexOfPressedButton {
        case 0:
            alertControllerCustom?.clouseAlert()
            break
        case 1:
            
            switch identifire {
            case .noWaterInBottle:
                alertControllerCustom?.clouseAlert()
                pourWaterIntoBottle(with: accessController)
                
            case .fillTheIsNotEmptyBottle:
                alertControllerCustom?.clouseAlert()
                pourWaterIntoBottle(with: accessController)
                
            case .deleteGotWaterData:
                alertControllerCustom?.clouseAlert()
                deleteGotWaterData()
                
            case .noBottlesWithWater:
                alertControllerCustom?.clouseAlert()
                //get one more bottle or premium
                if let containerVC = self.parent as? ContainerViewController {
                    containerVC.getOneMoreBottleInBottomMenu()
                } else {
                    getOneMoreBottleAdCustomAlertController()
                }
            case .getOneMoreBottle:
                //watch ads
                //alert controller will close automatically
                watchAdButtonAction(alertCustom: alertControllerCustom)
                
            case .getOneMoreBottleNotAvailable:
                //get premium
                becomePremiumAccountFromMenuViewController()
                alertControllerCustom?.clouseAlert()
                
                break
                
            case .tryAgainLoadAd:
                //get one more bottle or premium
                alertControllerCustom?.clouseAlert()
                getOneMoreBottleAdCustomAlertController()
                break
                
            case .notificationDenied:
                DispatchQueue.main.async {
                self.alertControllerCustom?.clouseAlert()
                if let containerVC = self.parent as? ContainerViewController {
                        let isPresentSettingsGoodResault = containerVC.openAppSettingsInsidePhoneSettings()
                        if !isPresentSettingsGoodResault {
                            self.notificationDeniedCustomAlertInMenuViewController(isProblemsWithOpenSettings: true)
                        }
                    } else {
                        self.notificationDeniedCustomAlertInMenuViewController(isProblemsWithOpenSettings: true)
                    }
                }
                
            default:
                break
            }
            
        case 2:
            alertControllerCustom?.clouseAlert()
            
            switch identifire {
            case .getOneMoreBottle, .noBottlesWithWater, .tryAgainLoadAd:
                becomePremiumAccountFromMenuViewController()
                //get premium
                break
            default:
                break
            }
            
        default:
            return
        }
    }
}
