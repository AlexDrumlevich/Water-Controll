//
//  ContainerViewControllerAlertControllerCustomExtension.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 15.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//AlertControllerCustomExtension

extension ContainerViewController: AlertControllerCustomActions {
    
    func buttonPressed(indexOfPressedButton: Int, identifire: AlertIdentifiers) {
        
        //close alert
        alertControllerCustom?.clouseAlert()
        removeViewBehindAlertAnderBanner()
        
        // button index pressed
        switch indexOfPressedButton {
        
        //cancel button
        case 0:
            
            switch identifire {
            
            case .getAdConsentNotForEEA, .tryGetAdConsentOneMoreTime, .requestIDFAWasDenied, .incorrectURL:
                //continue loading with out Ad
                if menuViewController == nil {
                    viewDidLoadContinueLoading()
                } else {
                    break
                }
            
            
            case .requestIDFAWillShow:
                //show request IDFA
                showRequestIDFA()
            default:
                break
            }
            
        case 1:
            
            switch identifire {
            //ads
            case .getAdConsentNotForEEA:
                saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: false, needToSaveInDataBase: true, needToSetTrueisAdsConsent: false)
                DispatchQueue.main.async {
                    self.prepareToRequestIDFA()
                }
                
            case .requestIDFAWillShow, .incorrectURL:
                // get premium
                becamePremiumAccaunt()
                break
                
            case .requestIDFAWasDenied:
                   let isPresentSettingsGoodResault =
                    openAppSettingsInsidePhoneSettings()
                    if !isPresentSettingsGoodResault {
                        requestIDFAWasDeniedCustomAlert(isProblemsWithOpenningPhoneSettings: true)
                    }
                if menuViewController == nil {
                    viewDidLoadContinueLoading()
                } else {
                    break
                }
             
                break
                
            case .tryGetAdConsentOneMoreTime:
                //get consent one more time
                prepareToGetAdConsent(callFromGetOneMoreBottle: callSaveFunctionFromGetOneMoreBottle)
                
                
            default:
                break
            }
            
        case 2:
            switch identifire {
            
            case .getAdConsentNotForEEA, .tryGetAdConsentOneMoreTime, .requestIDFAWasDenied:
                // get premium
                becamePremiumAccaunt()
                break
            default:
                break
            }
            
        default:
            break
        }
    }
}
