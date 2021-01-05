//
//  ExtentionSettingsViewControllerAlertControllerCustomDelegate.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 17.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController: AlertControllerCustomActions {
    
    func buttonPressed(indexOfPressedButton: Int, identifire: AlertIdentifiers) {
        
        guard alertControllerCustom != nil else {
            return
        }
      
        switch indexOfPressedButton {
            
            
        case 0:
            alertControllerCustom?.clouseAlert()
            
        case 1:
            
            switch identifire {
            case .deleteUser:
                alertControllerCustom?.clouseAlert()
                settingsViewControllerComplitionActions(.deleteUser)
                
            case .notificationDenied:
                alertControllerCustom?.clouseAlert()
                if let containerVC = self.parent as? ContainerViewController {
                   let isPresentSettingsGoodResault = containerVC.openAppSettingsInsidePhoneSettings()
                    if !isPresentSettingsGoodResault {
                        notificationDeniedCustomAlertInSettingsViewController(isProblemsWithOpenSettings: true)
                    }
                } else {
                    notificationDeniedCustomAlertInSettingsViewController(isProblemsWithOpenSettings: true)
                }
                break
                
            default:
                alertControllerCustom?.clouseAlert()
                
            }
            
        default:
            alertControllerCustom?.clouseAlert()
            
        }
    }
    
}
