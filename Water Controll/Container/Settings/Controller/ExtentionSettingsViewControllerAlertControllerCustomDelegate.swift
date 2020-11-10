//
//  ExtentionSettingsViewControllerAlertControllerCustomDelegate.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 17.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController: AlertControllerCustomActions {
    
    func buttonPressed(indexOfPressedPutton: Int, identifire: AlertIdentifiers) {
        
        guard alertControllerCustom != nil else {
            return
        }
        
        switch indexOfPressedPutton {
            
            
        case 0:
            alertControllerCustom?.clouseAlert()
            
        case 1:
            alertControllerCustom?.clouseAlert()
            
            switch identifire {
            case .deleteUser:
                settingsViewControllerComplitionActions(.deleteUser)
                
            default:
                return
            }
            
        default:
            return
        }
    }
    
}
