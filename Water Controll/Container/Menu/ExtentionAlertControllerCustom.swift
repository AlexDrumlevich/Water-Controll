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
    func buttonPressed(indexOfPressedPutton: Int, identifire: AlertIdentifiers) {
        
        switch indexOfPressedPutton {
        case 0:
            alertControllerCustom?.clouseAlert()
        case 1:
           alertControllerCustom?.clouseAlert()
            
            switch identifire {
            case .noWaterInBottle:
                pourWaterIntoBottle(with: accessController)
            case .fillTheIsNotEmptyBottle:
                pourWaterIntoBottle(with: accessController)
            case .deleteGotWaterData:
                deleteGotWaterData()
            case .noBottlesWithWater:
                //get one more bottle or premium
                getOneMoreBottleAdCustomAlertController()
            case .getOneMoreBottle:
                //watch ads
                presentRewardedAdToGetOneMoreBottle()
            case .tryAgainLoadAd:
                 //get one more bottle or premium
                getOneMoreBottleAdCustomAlertController()
                return
            default:
                return
            }
            
        case 2:
            alertControllerCustom?.clouseAlert()
            
            switch identifire {
            case .getOneMoreBottle:
                // get premium
                return
            case .noBottlesWithWater:
                // get premium
                return
            case .tryAgainLoadAd:
                 //get premium
                return
            default:
                return
            }
            
        default:
            return
        }
    }
    
    
}
