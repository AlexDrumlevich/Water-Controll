//
//  ExtensionSettingsViewControllerNotificationDeniedAlert.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 27.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

// notification denied
extension SettingsViewController {
    
    func notificationDeniedCustomAlertInSettingsViewController(isProblemsWithOpenSettings: Bool = false) {
        DispatchQueue.main.async { [self] in
            if alertControllerCustom != nil {
                alertControllerCustom?.clouseAlert()
            }
            
            alertControllerCustom = AlertControllerCustom()
            let alertTextNotificationDenied = """
            
            We use notifications to remind you to drink water. But you refused to notify the app. You can enable notifications in your phone settings.

            """
            
            let alertTextNotificationDeniedProblemsWithOpenSettings = """
            
            Sorry! We have problems with openning app notification settings. You can try to do this manually in your phone settings.

            """
            guard alertControllerCustom != nil else { return }
            alertControllerCustom!.createAlert(observer: self, alertIdentifire: .notificationDenied, view: view, text: isProblemsWithOpenSettings ? alertTextNotificationDeniedProblemsWithOpenSettings : alertTextNotificationDenied, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: isProblemsWithOpenSettings ? nil : "settings", thirdButtonText: nil, imageInButtons: true)
        }
        
    }
    
}
