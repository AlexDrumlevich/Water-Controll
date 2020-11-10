//
//  ExtentionSettingsViewControllerSubsettingsMenu.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 30.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//VolumeSubsettingsMenu
//we save type of value from this file when the user tapped ozButton or literButton
//we save full volume in bottle in ExtentionSettingsViewControllerActions.swift in function saveSettingsAndClouseSettingsViewControllerAndSubviews when the user tapped okButton

//okbutton is deseble when picker is spining

//we used temprary values for full volume and volume type wich save in data base when the user tappes ok button (if it`s first setup volume type - it save in data base when the user tappes button of volume type

extension SettingsViewController {
    
    //create and add VolumeSubsettingsMenu
    func showVolumeSubsettingsMenu() {
        volumeSubsettingsMenu = UIView()
        //setup full volume and volume type from data base
        fullBottleVolume = currentUser.fullVolume
        temperaryVolumeType = currentUser.volumeType
        volumeSubsettingsMenu.backgroundColor = .green
        //add view in Settings View Controller
        self.view.addSubview(volumeSubsettingsMenu)
        setConstraintsForVolumeSubsettingsMenu()
        
        addButtons()
        addPicker()
        setupButtonsImagesAndPickersVisible()
        
        hiddenButtons(buttons: [cancelButton], isHidden: settingsMode == .newUser || settingsMode == .firstUser || settingsMode == .needToSetupVolumeSettings)
        buttonsEnable(buttons: [cancelButton], isEnable: false)
        hiddenButtons(buttons: [plusButton, backButton, deleteButton, leftButton, rightButton], isHidden: true)
        
    }
    
    //delete and add VolumeSubsettingsMenu
    func deleteVolumeSubsettingsMenu() {
        
        self.volumeSubsettingsMenu.removeFromSuperview()
        self.volumeSubsettingsMenu = nil
    }
    
    
    
    //constraints
    
    
    
    func setConstraintsForVolumeSubsettingsMenu() {
        volumeSubsettingsMenu.translatesAutoresizingMaskIntoConstraints = false
        volumeSubsettingsMenu.topAnchor.constraint(equalTo: tableViewMainSettings.topAnchor).isActive = true
        volumeSubsettingsMenu.trailingAnchor.constraint(equalTo: tableViewMainSettings.trailingAnchor).isActive = true
        volumeSubsettingsMenu.bottomAnchor.constraint(equalTo: tableViewMainSettings.bottomAnchor).isActive = true
        volumeSubsettingsMenu.leadingAnchor.constraint(equalTo: tableViewMainSettings.leadingAnchor).isActive = true
        
        
        
    }
    
    
    
    
    // add buttons in VolumeSubsettingsMenu
    func addButtons() {
        
        //litter button
        literButton = UIButton()
        
        
        volumeSubsettingsMenu.addSubview(literButton)
        //constraints
        literButton.translatesAutoresizingMaskIntoConstraints = false
        literButton.widthAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 1/2, constant: -2 * constraintConstant).isActive = true
        literButton.heightAnchor.constraint(equalTo: literButton.widthAnchor).isActive = true
        literButton.topAnchor.constraint(equalTo: volumeSubsettingsMenu.topAnchor, constant: constraintConstant).isActive = true
        literButton.leadingAnchor.constraint(equalTo: volumeSubsettingsMenu.leadingAnchor, constant: constraintConstant).isActive = true
        //add actions
        literButton.addTarget(self, action: #selector(tappedLiterButton), for: .touchUpInside)
        
        
        //oz button
        ozButton = UIButton()
        
        volumeSubsettingsMenu.addSubview(ozButton)
        //constraints
        ozButton.translatesAutoresizingMaskIntoConstraints = false
        ozButton.widthAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 1/2, constant: -2 * constraintConstant).isActive = true
        ozButton.heightAnchor.constraint(equalTo: ozButton.widthAnchor).isActive = true
        ozButton.topAnchor.constraint(equalTo: volumeSubsettingsMenu.topAnchor, constant: constraintConstant).isActive = true
        ozButton.trailingAnchor.constraint(equalTo: volumeSubsettingsMenu.trailingAnchor, constant: -constraintConstant).isActive = true
        //add actions
        ozButton.addTarget(self, action: #selector(tappedOzButton), for: .touchUpInside)
        
    }
    
    
    
    // add pickers in VolumeSubsettingsMenu
    func addPicker() {
        
        //picker for liter integer
        literIntegerPicker = UIPickerView()
        literIntegerPicker.backgroundColor = .red
        
        literIntegerPicker.delegate = self
        literIntegerPicker.dataSource = self
        volumeSubsettingsMenu.addSubview(literIntegerPicker)
        
        literIntegerPicker.translatesAutoresizingMaskIntoConstraints = false
        literIntegerPicker.widthAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 0.47, constant: -2 * constraintConstant).isActive = true
        //literIntegerPicker.heightAnchor.constraint(equalTo: literButton.widthAnchor).isActive = true
        literIntegerPicker.bottomAnchor.constraint(equalTo: volumeSubsettingsMenu.bottomAnchor, constant: 2 * -constraintConstant).isActive = true
        literIntegerPicker.topAnchor.constraint(equalTo: literButton.bottomAnchor, constant: 2 * constraintConstant).isActive = true
        literIntegerPicker.leadingAnchor.constraint(equalTo: volumeSubsettingsMenu.leadingAnchor, constant: constraintConstant).isActive = true
        
        
        //picker for liter tenth
        
        literTenthPicker = UIPickerView()
        literTenthPicker.backgroundColor = .red
        //     literTenthPicker.isHidden = true
        literTenthPicker.delegate = self
        literTenthPicker.dataSource = self
        volumeSubsettingsMenu.addSubview(literTenthPicker)
        
        literTenthPicker.translatesAutoresizingMaskIntoConstraints = false
        literTenthPicker.widthAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 0.47, constant: -2 * constraintConstant).isActive = true
        //  literTenthPicker.heightAnchor.constraint(equalTo: literButton.widthAnchor).isActive = true
        literTenthPicker.topAnchor.constraint(equalTo: literButton.bottomAnchor, constant: 2 * constraintConstant).isActive = true
        literTenthPicker.bottomAnchor.constraint(equalTo: volumeSubsettingsMenu.bottomAnchor, constant: 2 * -constraintConstant).isActive = true
        literTenthPicker.trailingAnchor.constraint(equalTo: volumeSubsettingsMenu.trailingAnchor, constant: -constraintConstant).isActive = true
        
        // add dot  ot between literIntegerPicker and literTenthPicker
        dotBetweenliterIntegerPickerAndLiterTenthPicker = UIImageView()
        dotBetweenliterIntegerPickerAndLiterTenthPicker.image = UIImage(named: "dot")
        volumeSubsettingsMenu.addSubview(dotBetweenliterIntegerPickerAndLiterTenthPicker)
        //constraints
        dotBetweenliterIntegerPickerAndLiterTenthPicker.translatesAutoresizingMaskIntoConstraints = false
        dotBetweenliterIntegerPickerAndLiterTenthPicker.bottomAnchor.constraint(equalTo: literIntegerPicker.bottomAnchor).isActive = true
        dotBetweenliterIntegerPickerAndLiterTenthPicker.widthAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 0.03).isActive = true
        dotBetweenliterIntegerPickerAndLiterTenthPicker.heightAnchor.constraint(equalTo: dotBetweenliterIntegerPickerAndLiterTenthPicker.widthAnchor).isActive = true
        dotBetweenliterIntegerPickerAndLiterTenthPicker.centerXAnchor.constraint(equalTo: volumeSubsettingsMenu.centerXAnchor).isActive = true
        
        
        //picker for oz
        
        ozPicker = UIPickerView()
        ozPicker.backgroundColor = .red
        ozPicker.isHidden = true
        ozPicker.delegate = self
        ozPicker.dataSource = self
        
        volumeSubsettingsMenu.addSubview(ozPicker)
        
        ozPicker.translatesAutoresizingMaskIntoConstraints = false
        ozPicker.widthAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 0.7).isActive = true
        //ozPicker.heightAnchor.constraint(equalTo: volumeSubsettingsMenu.widthAnchor, multiplier: 0.5).isActive = true
        ozPicker.bottomAnchor.constraint(equalTo: volumeSubsettingsMenu.bottomAnchor, constant: 2 * -constraintConstant).isActive = true
        ozPicker.topAnchor.constraint(equalTo: literButton.bottomAnchor, constant: 2 * constraintConstant).isActive = true
        ozPicker.centerXAnchor.constraint(equalTo: volumeSubsettingsMenu.centerXAnchor).isActive = true
        
        
    }
    
    // setup button images and pickers values
    
    func setupButtonsImagesAndPickersVisible() {
        guard  let _ = currentUser.volumeType else {
            literButton.setImage(UIImage(named: "literButtonDeselected"), for: .normal)
            ozButton.setImage(UIImage(named: "ozButtonDeselected"), for: .normal)
            
            
            okButton.isHidden = true
            literIntegerPicker.isHidden = true
            literTenthPicker.isHidden = true
            dotBetweenliterIntegerPickerAndLiterTenthPicker.isHidden = true
            ozPicker.isHidden = true
            return
        }
        
        // button visible
        hiddenButtons(buttons: [okButton], isHidden: false)
        
        
        
        if temperaryVolumeType == "oz" {
            ozButton.setImage(UIImage(named: "ozButtonSelected"), for: .normal)
            literButton.setImage(UIImage(named: "literButtonDeselected"), for: .normal)
            literIntegerPicker.isHidden = true
            literTenthPicker.isHidden = true
            dotBetweenliterIntegerPickerAndLiterTenthPicker.isHidden = true
            ozPicker.isHidden = false
            ozPicker.selectRow(fullBottleVolume != 0 ? Int(fullBottleVolume) : 1, inComponent: 0, animated: true)
            
        } else {
            literButton.setImage(UIImage(named: "literButtonSelected"), for: .normal)
            ozButton.setImage(UIImage(named: "ozButtonDeselected"), for: .normal)
            literIntegerPicker.isHidden = false
            literTenthPicker.isHidden = false
            dotBetweenliterIntegerPickerAndLiterTenthPicker.isHidden = false
            ozPicker.isHidden = true
            literIntegerPicker.selectRow(fullBottleVolume != 0 ? Int(fullBottleVolume) : 0, inComponent: 0, animated: true)
            literTenthPicker.selectRow(fullBottleVolume != 0 ? Int(Float.rounded((fullBottleVolume - Float(Int(fullBottleVolume))) * 10)()) : 1, inComponent: 0, animated: true)
            
        }
    }
}









