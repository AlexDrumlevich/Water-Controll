//
//  ExtensionVolumeSubsettingsChouseTypeCustomAlert.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 13.12.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//chouse Volume Type Custom Alert In Volume Subsettings menu
extension SettingsViewController {
    
    enum VolumeAlertType {
        case selectVolumeType, doctorConsultation
    }
    
    func chouseVolumeTypeCustomAlertInVolumeSubsettingsMenu(type: VolumeAlertType) {
        
        DispatchQueue.main.async { [self] in
            if alertControllerCustom != nil {
                alertControllerCustom?.clouseAlert()
            }
            
            alertControllerCustom = AlertControllerCustom()
            
            
            let name = currentUser.name
            let greetingText = AppTexts.firstGreetingWord + (name == nil ? "! " : ", " + name! + "! ")
            let alertTextChouseVolumeType = AppTexts.alertTextChouseVolumeType
                
            let doctorConsultationText = AppTexts.doctorConsultationText
            
            let alertText = type == .selectVolumeType ? greetingText + alertTextChouseVolumeType : doctorConsultationText
            
            guard alertControllerCustom != nil else { return }
            alertControllerCustom!.createAlert(observer: self, alertIdentifire: .general, view: type == .selectVolumeType ? blurViewForBottleVolumeMenu.contentView : view, text: alertText, imageName: nil, firstButtonText: type == .selectVolumeType ? nil : "Ok", secondButtonText: nil, thirdButtonText: nil, imageInButtons: false)
        }
        
    }
    
}
