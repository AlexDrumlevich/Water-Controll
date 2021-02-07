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
            
            case .getAdFirstConsentForEEA:
                // ad - free version
                sratrPurchasing()
                break
                
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
                //start ads
                startGoogleAds()
                
                saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: false, needToSaveInDataBase: true, needToSetTrueisAdsConsent: false)
                DispatchQueue.main.async {
                    self.prepareToRequestIDFA()
                }
                
            case .getAdFirstConsentForEEA:
                
                saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: false, needToSaveInDataBase: true, needToSetTrueisAdsConsent: false)
                DispatchQueue.main.async {
                    //create get consent form
                    self.createGetConsentForm(callFromGetOneMoreBottle: self.menuViewController != nil ? self.menuViewController.isGetConsentFormCallFromGetOneMoreBottle : false)
                }
                
            case .requestIDFAWillShow, .incorrectURL:
                // get premium
                //becamePremiumAccaunt()
                sratrPurchasing()
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
                //becamePremiumAccaunt()
                sratrPurchasing()
                break
            default:
                break
            }
            
        default:
            break
        }
    }
}
