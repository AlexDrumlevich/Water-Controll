//
//  ExtentionSettingsViewControllerTableviewDelegates.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
//MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //tableViewMainSettings
        if tableView.tag == 0 {
            
            guard let settingsViewControllerTableViewCellType = SettingsViewControllerTableViewCellType(rawValue: indexPath.row) else {return 50}
            // hide pour water in bottle fill type if now a ads version
            //hide restore purchase if we in ads free version
            if accessController != nil {
                if !accessController!.premiumAccount == true && settingsViewControllerTableViewCellType == .isAutoFillWater {
                    return 0
                }
                if accessController!.premiumAccount == true && settingsViewControllerTableViewCellType == .restorePurchases {
                    return 0
                }
            }
            return settingsViewControllerTableViewCellType.cellHeightMultiplicator * view.bounds.height
             // notifications time a day
        } else if tableView.tag == 2 {
            return setupCellHideInTableViewNotificationsTimeADay()
        } else {
            return setupCellHeight(indexPath: indexPath) 
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
        //tableViewMainSettings
        if tableView.tag == 0 {
            //if text fild is editing and we touch in cell in tabel view
            guard !nameTextField.isEditing else { return }
            
            
            //get SettingsViewControllerTableViewCellType by raw value (raw value = selected row)
            guard let settingsViewControllerTableViewCellType = SettingsViewControllerTableViewCellType(rawValue: indexPath.row) else {
                print("no action for cell in tble view settins view controller of row: \(indexPath.row)")
                return
            }
            
            //actions depend of settingsViewControllerTableViewCellType wich depend on tapped cell
            switch settingsViewControllerTableViewCellType {
            case .name:
                //activate text field as first responder
                if isKeyboardHidden {
                nameTextField.becomeFirstResponder()
                    tableViewMainSettings.isScrollEnabled = false
                }
            case .bottleSettings:
                // show Volume Subsettings Menu when the user tapped cell of bottle settings
                if volumeSubsettingsMenu == nil {
                    self.showVolumeSubsettingsMenu()
                }
            case .notification:
                if notificationSubsettingsMenu == nil {
                    self.showNotificationSubsettingsMenu()
                }
            
            case .isAutoFillWater:
                
                currentUser.isAutoFillBottleType = !currentUser.isAutoFillBottleType
                settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
                tableView.reloadRows(at: [indexPath], with: .fade)
                
            case .deleteUser:
                deleteUserAlertController()
               
            case .restorePurchases:
                break
            }
        }
    }
}

//MARK: UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //notificationSubsettingsMenu
        if tableView.tag == 1 {
            return 8
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // tableViewMainSettings
        if tableView.tag == 0 {
            return SettingsViewControllerTableViewCellType.allCases.count
            // notifications time a day
        } else if tableView.tag == 2 {
            return numberOfRowsInTableViewNotificationsTimeADay()
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //notification subsettings menu
        let notificationsText = " notifications"
        if tableView.tag == 1 {
            let titleADayPart = (currentUser.volumeType == "oz" ? NotificationSettingsTableViewCellTypeSundayFirst(rawValue: section)?.sectionTitle : NotificationSettingsTableViewCellTypeMondayFirst(rawValue: section)?.sectionTitle) ?? ""
            return titleADayPart
               //notifications time a day menu
        } else if tableView.tag == 2 {
            return setupSectionTitleInTableViewNotificationsTimeADay() + notificationsText
        } else {
            return ""
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        //tableViewMainSettings
        if tableView.tag == 0 {
                print("tableViewMainSettings")
            let cell = SettingsTableViewCell()
            cell.setupCell(with: SettingsViewControllerTableViewCellType(rawValue: indexPath.row)!)
            switch SettingsViewControllerTableViewCellType(rawValue: indexPath.row) {
            case .name:
                //additional setup text fild and add actions
                nameTextField = cell.textField
                nameTextField.placeholder = "Change name"//currentUser.name ?? ""
                nameTextField.enablesReturnKeyAutomatically = true
                nameTextField.autocorrectionType = .no
                nameTextField.autocapitalizationType = .sentences
                if settingsMode == .firstUser || settingsMode == .newUser {
                    nameTextField.becomeFirstResponder()
                    tableViewMainSettings.isScrollEnabled = false
                    buttonsEnable(buttons: [okButton], isEnable: !nameTextField.text!.isEmpty)
                }
                //implementation in ExtentionSettingsViewControllerActions.swift
                nameTextField.addTarget(self, action: #selector(nameTextFieldBeginEditing), for: .editingDidBegin)
                nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
                nameTextField.addTarget(self, action: #selector(nameTextFieldEndEditing), for: .editingDidEndOnExit)
                //label "name" in text field
                youNameLabelInCell = cell.youNameLabel
                youNameLabelInCell.isHidden = !currentUser.name!.isEmpty
                if currentUser.name!.isEmpty {
                    nameTextField.placeholder = ""
                }
                
            case .bottleSettings:
                volumeBottleImageView = cell.bottleImageView
                volumeLabel = cell.volumeLabel
                //setup image and volume from ExtentionSettingsViewControllerTableview
                setupVolumeBottleCell()
            
            case .isAutoFillWater:
                isAutoFillBottleTypeLabel = cell.isAutoFillBottleLabelView
                setupIsAutoFillBottleCell()
                
                
            default:
                break
            }
            return cell
            
            //notification subsettings menu
        } else if tableView.tag == 1 {
            
            let cell = NotificationSubsettingsMenuCell()
            //blinkin stop label
            defer {
                    setupBlinkingStopLabel(isBlinkin: notificationsStracture[indexPath.section].stop - notificationsStracture[indexPath.section].start <= 0,  sectionNumber: indexPath.section, label: cell.stopLabel)
            }
            //method from ExtentionSettingsViewControllerNotificationSubsettingsMenu
            return setupNotificationSettingsTableViewCells(cell: cell, indexPath: indexPath)
        
             //notifications time subsettings menu
        } else {
                  print("notifications time subsettings menu")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTimeSubsettingsMenuCell.cellID, for: indexPath) as? NotificationsTimeSubsettingsMenuCell else {
                print("can`t get cell as  NotificationsTimeSubsettingsMenuCell in cellForRowAt indexPath")
                return UITableViewCell()
            }
            return setupNotificationsTimeSubsettingsMenuCells(cell: cell, indexPath: indexPath)
        }
    }
}
