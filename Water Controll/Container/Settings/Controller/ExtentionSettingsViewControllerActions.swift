//
//  ExtentionSettingsViewControllerActions.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 04.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    
    //MARK: actions for plus, back, cancel, ok buttons
    
    func addActions() {
        //add action for back button - clouse Settings View Controller
        backButton.addTarget(self, action: #selector(clouseSettingsViewControllerAndSubviews), for: .touchUpInside)
        
        plusButton.addTarget(self, action: #selector(addUserAction), for: .touchUpInside)
        
        okButton.addTarget(self, action: #selector(saveSettingsAndClouseSettingsViewControllerAndSubviews), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        deleteButton.addTarget(self, action: #selector(deleteUserAction), for: .touchUpInside)
        
        rightButton.addTarget(self, action: #selector(changeUserNext), for: .touchUpInside)
        
        leftButton.addTarget(self, action: #selector(changeUserPrevious), for: .touchUpInside)
    }
    
    
    
    //clouse Settings View Controller And Subviews with out safe
    @objc func clouseSettingsViewControllerAndSubviews() {
        //if volumeSubsettingsMenu is open - first of all we clouse volumeSubsettingsMenu
        if self.volumeSubsettingsMenu != nil {
            self.deleteVolumeSubsettingsMenu()
        } else {
            //   clouse Settings View Controller via closure in container view controller
            settingsViewControllerComplitionActions(.closeSettingsViewContainer)
        }
    }
    
    
    //safe settings and clouse Settings View Controller And Subviews
    @objc func saveSettingsAndClouseSettingsViewControllerAndSubviews() {
        //if volumeSubsettingsMenu is open - first of all we safe volume settingc and clouse volumeSubsettingsMenu
        
        
        //if we are in volume settings
        if self.volumeSubsettingsMenu != nil {
            
            //set to not increese upper then full bottle
            var volumeInBottle = currentUser.currentVolumeInBottle
            currentUser.currentVolumeInBottle = 0
            
            //volume type
            currentUser.volumeType = temperaryVolumeType
            
            // got water
            if temperaryCurrentVolumeGotWater != nil {
            currentUser.currentVolume = temperaryCurrentVolumeGotWater!
            }
         
            //full bottle volume
            currentUser.fullVolume = fullBottleVolume != 0 ? fullBottleVolume : currentUser.fullVolume != 0 ? currentUser.fullVolume : currentUser.volumeType == "oz" ? 1 : 0.1
            currentUser.middlePourWaterVolume = currentUser.volumeType == "oz" ? 9 : 250
            
            //volume in bottle
            if temporaryCurrentVolumeInBottle != nil {
                volumeInBottle = temporaryCurrentVolumeInBottle!
            }
            if volumeInBottle <= currentUser.fullVolume {
                currentUser.currentVolumeInBottle = volumeInBottle
            } else {
                currentUser.currentVolumeInBottle = currentUser.fullVolume
            }
           
            
           
            
            // add first got water data with zero volume and curren data
            //this method also calls if we save new settings and this method change current volume in bottle if the user changed volume type
            if let containerViewController = self.parent as? ContainerViewController {
                  containerViewController.addPourWaterData(wasPoured: 0, date: Date(), user: currentUser)
            }
          
            
            //conversely notifications if needed 
            if let notifications = currentUser.notifications?.mutableCopy() as? NSMutableOrderedSet {
                if currentUser.volumeType == "oz" {
                    if (notifications[1] as? Notificaton)?.name != NotificationSettingsTableViewCellTypeSundayFirst.sunday.notificationName {//.sectionTitle {
                        notifications.moveObjects(at: [7], to: 1)
                    }
                } else {
                    if (notifications[1] as? Notificaton)?.name == NotificationSettingsTableViewCellTypeMondayFirst.sunday.notificationName {//.sectionTitle {
                        notifications.moveObjects(at: [1], to: 7)
                    }
                }
                currentUser.notifications = notifications
                
              
            }
            
            
            //save in data base
            settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
            setupVolumeBottleCell()
            if settingsMode == .newUser || settingsMode == .firstUser || settingsMode == .needToSetupVolumeSettings {
                self.showNotificationSubsettingsMenu()
            } else {
                settingsMode = .waitAction
                // hiddenButtons(buttons: [deleteButton], isHidden: false)
                hiddenButtons(buttons: [plusButton, backButton], isHidden: false)
                hiddenButtons(buttons: [leftButton, rightButton], isHidden: isSinglUser)
                hiddenButtons(buttons: [okButton, cancelButton], isHidden: true)
            }
            //method from ExtentionSettingsViewControllerVolumeSubsettingsMenu
            self.deleteVolumeSubsettingsMenu()
            //update MenuViewController
            settingsViewControllerComplitionActions(.updateMenuViewController)
           //update GameViewController
           // settingsViewControllerComplitionActions(.updateGameViewController)
            
            print("OK ACTION IN volumeSubsettingsMenu")
            
            
            //if we are in notification settings
        } else if notificationSubsettingsMenu != nil && notificationsTimeSubsettingsMenu == nil {
            
            okButton.isHidden = true
            cancelButton.isHidden = true
            // we remove early  notifications
            guard let identifire = currentUser.notificationIdentifire else {
                print("error of creating notification")
                if notificationSubsettingsMenu != nil {
                notificationSubsettingsMenu.removeFromSuperview()
                }
                return
            }
            
        
            notificationCenter.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifire])
           
            notificationCenter.notificationCenter       .removeDeliveredNotifications(withIdentifiers: [identifire])
            
            self.translateNotificationsFromNotificationStructureToNotificationClass()
            /* we save context and create notifications after translate will finish in complition of notifications time create
             translateNotificationsFromNotificationStructureToNotificationClass -> createScheduleNotifications -> okActionNotificationsTimeSubsettingsMenu (delite notificationSubsettingsMenu and  SsettingsMenu in needed)
             */

        print("OK ACTION IN notificationSubsettingsMenu")
        
    } else if !isKeyboardHidden {    //if keyboard
    if nameTextField.text!.isEmpty { return }
    endEditingNameTextField()
    
    print("OK ACTION IN !isKeyboardHidden")
    
    //if we`re in notificationsTimeSubsettingsMenu
    } else if notificationsTimeSubsettingsMenu != nil {
    okActionInNotificationsTimeSubsettingsMenu()
    } else {
    // save settings and clouse Settings View Controller via closure in container view controller
    settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
    settingsViewControllerComplitionActions(.closeSettingsViewContainer)
    print("OK ACTION IN else")
    }
    
    
}

@objc func addUserAction() {
    settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
    settingsViewControllerComplitionActions(.addNewUser)
}


@objc func cancelAction() {
    if !isKeyboardHidden {
        nameTextField.resignFirstResponder()
        tableViewMainSettings.isScrollEnabled = true
        if settingsMode == .newUser {
            settingsViewControllerComplitionActions(.deleteUser)
        } else {
            nameTextField.text = ""
            nameTextField.placeholder = AppTexts.changeNameAppTexts// currentUser.name
            nameLabel.text = currentUser.name
            // hiddenButtons(buttons: [deleteButton], isHidden: false)
            hiddenButtons(buttons: [plusButton, backButton], isHidden: false)
            hiddenButtons(buttons: [leftButton, rightButton], isHidden: isSinglUser)
        }
        
    } else if volumeSubsettingsMenu != nil {
        deleteVolumeSubsettingsMenu()
        hiddenButtons(buttons: [okButton, cancelButton], isHidden: true)
        // hiddenButtons(buttons: [deleteButton], isHidden: false)
        hiddenButtons(buttons: [plusButton, backButton], isHidden: false)
        hiddenButtons(buttons: [leftButton, rightButton], isHidden: isSinglUser)
    } else if notificationSubsettingsMenu != nil && notificationsTimeSubsettingsMenu == nil {
        deleteNotificationSubsettingsMenu()
        if settingsMode == .needToSetupNotificationSettingsOnly || settingsMode == .firstUser || settingsMode == .newUser {
            //if we came from main screen
            settingsViewControllerComplitionActions(.closeSettingsViewContainer)
        } else {
            hiddenButtons(buttons: [okButton, cancelButton], isHidden: true)
            // hiddenButtons(buttons: [deleteButton], isHidden: false)
            hiddenButtons(buttons: [plusButton, backButton], isHidden: false)
            hiddenButtons(buttons: [leftButton, rightButton], isHidden: isSinglUser)
        }
        //close notificationsTimeSubsettingsMenu
    } else if notificationsTimeSubsettingsMenu != nil {
        deleteNotificationsTimeSubsettingsMenu()
    }
}

@objc func deleteUserAction() {
    settingsViewControllerComplitionActions(.deleteUser)
    
}


@objc func changeUserNext() {
    settingsViewControllerComplitionActions(.changeUserNext)
}

@objc func changeUserPrevious() {
    settingsViewControllerComplitionActions(.changeUserPrevious)
}

}
