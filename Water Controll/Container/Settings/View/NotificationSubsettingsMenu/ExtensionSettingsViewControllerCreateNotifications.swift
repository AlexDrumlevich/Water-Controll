//
//  ExtensionSettingsViewControllerCreateNotifications.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 28.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    
    
    
    //
    
    func setupNotificationCenter() {
        notificationCenter = Notifications()
        //  notificationCenter.notificationCenter.delegate = notificationCenter
        notificationCenter.getNotificationSettings { (status) in
            switch status {
            case .authorized:
                //create table view
                self.createTableViewNotificationSubsettingsMenu()
            case .notDetermined:
                self.notificationCenter.requestAutorization { (result) in
                    if result {
                        //create table view
                        self.createTableViewNotificationSubsettingsMenu()
                    } else {
                        if self.settingsMode == .firstUser || self.settingsMode == .newUser || self.settingsMode == .needToSetupNotificationSettingsOnly {
                            self.settingsViewControllerComplitionActions(.closeSettingsViewContainer)
                        }
                    }
                }
            case .denied:
                var showAlertInMenuVC = false
                if self.settingsMode == .firstUser || self.settingsMode == .newUser || self.settingsMode == .needToSetupNotificationSettingsOnly {
                    showAlertInMenuVC = true
                    self.settingsViewControllerComplitionActions(.showDeniedNotificationCustomAlert(showAlertInMenuVC))
                    self.settingsViewControllerComplitionActions(.closeSettingsViewContainer)
                    break
                }
                self.settingsViewControllerComplitionActions(.showDeniedNotificationCustomAlert(showAlertInMenuVC))
                
                
                
            case .provisional:
                break
            case .ephemeral:
                //create table view
                self.createTableViewNotificationSubsettingsMenu()
            @unknown default:
                print("new cases are available in settings.authorizationStatus")
            }
        }
    }
    
    
    /*
     //depricted - now we only update notifications and create them inside updating i Container VC
    //create and add notifications
    
    func createScheduleNotifications() {
        //    DispatchQueue.main.async {
        
        //create actions categories
        self.notificationCenter.createTimeToDrinkNotificationCategory(with: self.currentUser.notificationIdentifire!)
        
        var isNeedConvertSundayFist = false
        
        if (self.notifications[1] as? Notificaton)?.name != NotificationSettingsTableViewCellTypeSundayFirst.sunday.notificationName {//.sectionTitle {
            self.notifications.moveObjects(at: [7], to: 1)
            isNeedConvertSundayFist = true
        }
        //self.notificationCenter.testNotification(timeInterval: 5)
        
        for notificationItemIndex in 1 ..< Int(self.notifications.count) {
            guard  let notification = self.notifications[notificationItemIndex] as? Notificaton else {
                print("can`t get notification in func createScheduleNotifications" )
                return
            }
            
            
            // miss notification if notification is`t active
            if !notification.isActive {
                if notificationItemIndex < Int(self.notifications.count) - 1 {
                    continue
                } else {
                    self.okActionNotificationSubsettingsMenu()
                    return
                }
            }
            
            var day = notificationItemIndex
            
            guard let notificationsTime = notification.notificationsTime as? NSMutableOrderedSet else {
                print("can`t get notificationsTime in func createScheduleNotifications" )
                return
            }
            
            guard notificationsTime.count >= 2 else {
                print("can`t get min 2 notifications time in func createScheduleNotifications" )
                return
            }
            
            guard let fistNotificationTime = ((notificationsTime[0] as? NotificationsTime)?.notificationTime) else {
                print("can`t get first time in func createScheduleNotifications" )
                return
            }
            
            
            for timeNotifivationItemIndex in 0 ..< Int(notificationsTime.count) {
                
                guard let notificationTime = (notificationsTime[timeNotifivationItemIndex] as? NotificationsTime) else { return }
                let time = notificationTime.notificationTime
                if time < fistNotificationTime {
                    day = day != 7 ? day + 1 : 1
                }
                
                let hour = Int(time / 60)
                let minute = Int(time % 60)
                
                let isLast = notificationItemIndex == self.notifications.count - 1 && timeNotifivationItemIndex == notificationsTime.count - 1
                
                
                
                let name = self.currentUser.name ?? ""
                self.notificationCenter.createScheduleNotification(title: AppTexts.firstGreetingWord + " " + name + "!", body: (self.parent as! ContainerViewController).getNotificationBodyText(), categoryIdentifier: self.currentUser.notificationIdentifire!, threadIdentifier: self.currentUser.identifire ?? NotificationCategories.timeToDrink.rawValue, weekDay: day, hour: hour, minute: minute, isLast: isLast) {
                    // if we create last notification time in last day we call okActionNotificationSubsettingsMenu, wich clouses setinngs menu or only notification subsettings menu
                    if isLast {
                        
                        if isNeedConvertSundayFist {
                            self.notifications.moveObjects(at: [1], to: 7)
                        }
                        self.okActionNotificationSubsettingsMenu()
                        
                    }
                    // }
                }
            }
        }
    }
 */
    
}
