//
//  ExtentionVolumeSubsettingsButtonActions.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    //implementation button actions
    
    @objc func tappedLiterButton() {
        //anti double click defend
        guard temperaryVolumeType != "liter" else { return }
        //save in data base volume type and setup buton images and pickers values
        //clouse settings view controller - resolve in container view controller
        //we save in data base if volume tupe was`t setup yet
        if currentUser.volumeType == nil {
            alertControllerCustom?.clouseAlert()
            chouseVolumeTypeCustomAlertInVolumeSubsettingsMenu(type: .doctorConsultation)
            currentUser.volumeType = "liter"
            currentUser.fullVolume = 0.1
            settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
        }
        
        temperaryVolumeType = "liter"
        
        //translate oz in liters if the user setuped volume in oz early
        if fullBottleVolume != 0 {
            let volumeInLiters = fullBottleVolume / 33.81
            if let roundedVolumeInLiter = Float(String(format: "%.1f", volumeInLiters)) {
                fullBottleVolume = roundedVolumeInLiter >= 0.1 && roundedVolumeInLiter <= Float(numberOfMaxIntegerLites) - Float(0.1) ? roundedVolumeInLiter : roundedVolumeInLiter < 0.1 ? 0.1 : Float(numberOfMaxIntegerLites) - Float(0.1)
            } else {
                fullBottleVolume = 0.1
            }
        }
        
        // translate current volume in bottle
        let volumeInLitersInBottle = currentUser.currentVolumeInBottle / 33.81
        if let roundedVolumeInLitersInBottle = Float(String(format: "%.1f", volumeInLitersInBottle)) {
            temporaryCurrentVolumeInBottle = roundedVolumeInLitersInBottle >= 0.1 && roundedVolumeInLitersInBottle <= Float(numberOfMaxIntegerLites) - Float(0.1) ? roundedVolumeInLitersInBottle : roundedVolumeInLitersInBottle < 0.1 ? 0.1 : Float(numberOfMaxIntegerLites) - Float(0.1)
        } else {
            temporaryCurrentVolumeInBottle = 0.1
        }
        
        // translate got water
        let volumeGotWater = currentUser.currentVolume / 33.81
        if let roundedVolumevolumeGotWater = Float(String(format: "%.1f", volumeGotWater)) {
            temperaryCurrentVolumeGotWater = roundedVolumevolumeGotWater
        } else {
            temperaryCurrentVolumeGotWater = 0.1
        }
        
        
        
        
        
        setupButtonsImagesAndPickersVisible()
    }
    
    @objc func tappedOzButton() {
        //anti double click defend
        guard temperaryVolumeType != "oz" else { return }
        
        //clouse settings view controller - resolve in container view controller
        //we save in data base if volume tupe was`t setup yet
        //save in data base volume type and setup buton images and pickers values
        if currentUser.volumeType == nil {
            alertControllerCustom?.clouseAlert()
            chouseVolumeTypeCustomAlertInVolumeSubsettingsMenu(type: .doctorConsultation)
            currentUser.volumeType = "oz"
            currentUser.fullVolume = 1
            settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
        }
        temperaryVolumeType = "oz"
        
        //translate liter in oz if the user setuped volume in liters early
        if fullBottleVolume != 0 {
            let volumeInOz = Float(Int(fullBottleVolume * 33.81))
            fullBottleVolume = volumeInOz >= 1 && volumeInOz <= Float(numberOfMaxOz - 1) ? volumeInOz : volumeInOz > Float(numberOfMaxOz - 1) ? Float(numberOfMaxOz - 1) : 1
        }
        
        // translate current volume in bottle
        let volumeInOzInBottle = Float(Int(currentUser.currentVolumeInBottle * 33.81))
        temporaryCurrentVolumeInBottle = volumeInOzInBottle >= 1 && volumeInOzInBottle <= Float(numberOfMaxOz - 1) ? volumeInOzInBottle : volumeInOzInBottle > Float(numberOfMaxOz - 1) ? Float(numberOfMaxOz - 1) : 1
        
        // translate got water
        temperaryCurrentVolumeGotWater = Float(Int(currentUser.currentVolume * 33.81))
        
        
        setupButtonsImagesAndPickersVisible()
    }
    
}
