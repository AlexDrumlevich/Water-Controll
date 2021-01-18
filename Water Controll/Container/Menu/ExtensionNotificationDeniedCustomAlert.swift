//
//  ExtensionNotificationDeniedCustomAlert.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 29.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

// notification denied
extension MenuViewController {
    
    func notificationDeniedCustomAlertInMenuViewController(isProblemsWithOpenSettings: Bool = false) {
        DispatchQueue.main.async { [self] in
            if alertControllerCustom != nil {
                alertControllerCustom?.clouseAlert()
            }
            
            alertControllerCustom = AlertControllerCustom()
          
            let alertTextNotificationDenied = AppTexts.alertTextNotificationDeniedAppTexts
            
            let alertTextNotificationDeniedProblemsWithOpenSettings = AppTexts.alertProblemsWithOpenSettingsAppTexts
            
            
            guard alertControllerCustom != nil else { return }
            alertControllerCustom!.createAlert(observer: self, alertIdentifire: .notificationDenied, view: view, text: isProblemsWithOpenSettings ? alertTextNotificationDeniedProblemsWithOpenSettings : alertTextNotificationDenied, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: isProblemsWithOpenSettings ? nil : "settings", thirdButtonText: nil, imageInButtons: true)
        }
        
    }
    
}
