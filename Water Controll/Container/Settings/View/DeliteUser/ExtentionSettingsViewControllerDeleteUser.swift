//
//  ExtentionSettingsViewControllerDeleteUser.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 20.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
     func deleteUserAlertController() {
      
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let name = currentUser.name ?? AppTexts.meAppTexts
        
        let textDoYouReallyWantToDeleteMe = AppTexts.doYouReallyWantToDeleteMeAppTexts + name + "?"
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .deleteUser, view: view, text: textDoYouReallyWantToDeleteMe, imageName: "cryingBottle", firstButtonText: "cancelSmallBlue", secondButtonText: "delete", thirdButtonText: nil, imageInButtons: true)
     
    }
    
}
