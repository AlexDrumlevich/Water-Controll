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
            let greetingText = "Hi" + (name == nil ? "! " : ", " + name! + "! ")
            let alertTextChouseVolumeType = """
            Please select the volume type: "Liter" or "Oz"
            """
            
            let doctorConsultationText = """
            Caution!
            The app only controls the amount of water you drink from the daily volume you choose. To choose a daily volume you should consult your doctor.
            """
            
            let alertText = type == .selectVolumeType ? greetingText + alertTextChouseVolumeType : doctorConsultationText
            
            guard alertControllerCustom != nil else { return }
            alertControllerCustom!.createAlert(observer: self, alertIdentifire: .general, view: type == .selectVolumeType ? blurViewForBottleVolumeMenu.contentView : view, text: alertText, imageName: nil, firstButtonText: type == .selectVolumeType ? nil : "Ok", secondButtonText: nil, thirdButtonText: nil, imageInButtons: false)
        }
        
    }
    
}
