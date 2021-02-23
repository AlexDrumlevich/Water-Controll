//
//  ContainerViewControllerNotificationUpdate.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 29.08.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation

struct NotificationDataToNotificationsCreate {
    let name: String
    let day: Int
    let hour: Int
    let minute: Int
    let notificationIdentifire: String
}


extension ContainerViewController {
    
    // call from getCurrentUsersAndAccessControllerFromLocalDataBase and when we change notifications
    func updateNotifications() {
    
        let notificationCenter = Notifications()
        
      
        
        notificationCenter.getNotificationSettings { (status) in
            switch status {
            case .authorized:
                self.addNewNotifications(notificationCenter: notificationCenter)
            default:
                return
            }
        }
    }
    
    
    
    
    
    private func addNewNotifications(notificationCenter: Notifications) {
        
        
        var notificationsDataArrayToSetNotificationCreating = [NotificationDataToNotificationsCreate]()
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.weekday, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let currentTime = (hour * 60) + minute
        var currentDay = day
        var dayInDatabase = day
        var limitControl: Int = 0
        
        
        for (indexUser, user) in users.enumerated() {
            guard user.notificationIdentifire != nil else { return }
            
            // day depend on monday or sunday is first
            currentDay = user.volumeType == "oz" ? day : day - 1 > 0 ? day - 1 : 7
            dayInDatabase = currentDay
            guard let notifications = user.notifications else { return }
            guard notifications.count == 8 else { return }
            
            
            //notifications 1 - 7
            for _ in 1 ... notifications.count - 1 {
                
                // day sundayFirstdepend on monday or sunday is first
                let dayToSetNotification = user.volumeType == "oz" ? dayInDatabase : dayInDatabase + 1 == 8 ? 1 : dayInDatabase + 1
                
                guard let notification = notifications[dayInDatabase] as?
                        Notificaton else { return }
                //continue if is not active
                if !notification.isActive {
                    dayInDatabase = dayInDatabase + 1 == 8 ? 1 : dayInDatabase + 1
                    continue
                }
                guard let notificationTimes = notification.notificationsTime else { return }
                
                
                
                //notifications time
                for notificationTime in notificationTimes {
                    
                    guard let notificationDate = notificationTime as? NotificationsTime else { return }
                    
                    let time = notificationDate.notificationTime
                    let hourNotifiction = Int(time / 60)
                    let minuteNotification = Int(time % 60)
                    
                    
                    //if we are in next day or did a loop and backed in start day
                    if dayToSetNotification != day {
                        
                        var wasAdded = false
                        for (index, notificationData) in notificationsDataArrayToSetNotificationCreating.enumerated() {
                            
                            //if we have day less than current day it mean that that day mast be after days wich more than current day so we create support let day in time line
                            let dayInTimeLineFromNotificationData = notificationData.day < day ? notificationData.day + 7 : notificationData.day
                            let dayToSetNotificationInTimeLine = dayToSetNotification < day ? dayToSetNotification + 7 : dayToSetNotification
                            if dayInTimeLineFromNotificationData > dayToSetNotificationInTimeLine && notificationData.day != day ||
                                notificationData.day == day && (notificationData.hour * 60) + notificationData.minute <= currentTime ||
                                notificationData.day == dayToSetNotification && (notificationData.hour * 60) + notificationData.minute >= time {
                                notificationsDataArrayToSetNotificationCreating.insert(NotificationDataToNotificationsCreate(name: user.name ?? "", day: dayToSetNotification, hour: hourNotifiction, minute: minuteNotification, notificationIdentifire: user.notificationIdentifire!), at: index)
                                
                                wasAdded = true
                                break
                            }
                        }
                        
                        if !wasAdded {
                            notificationsDataArrayToSetNotificationCreating.append(NotificationDataToNotificationsCreate(name: user.name ?? "", day: dayToSetNotification, hour: hourNotifiction, minute: minuteNotification, notificationIdentifire: user.notificationIdentifire!))
                        }
                        limitControl += 1
                        if limitControl == 60 {
                            break
                        }
                        //if we are in current day
                    } else {
                        
                        var wasAdded = false
                        
                        
                        for (index, notificationData) in notificationsDataArrayToSetNotificationCreating.enumerated() {
                            if time > currentTime {
                                
                                
                                if notificationData.day == day && time <= (notificationData.hour * 60) + notificationData.minute && (notificationData.hour * 60) + notificationData.minute > currentTime || notificationData.day != day ||
                                    notificationData.day == day && (notificationData.hour * 60) + notificationData.minute <= currentTime {
                                    
                                    notificationsDataArrayToSetNotificationCreating.insert(NotificationDataToNotificationsCreate(name: user.name ?? "", day: dayToSetNotification, hour: hourNotifiction, minute: minuteNotification, notificationIdentifire: user.notificationIdentifire!), at: index)
                                    wasAdded = true
                                    break
                                }
                                
                                
                            } else {
                                
                                if  time <= (notificationData.hour * 60) + notificationData.minute && notificationData.day == day && (notificationData.hour * 60) + notificationData.minute <= currentTime {
                                    notificationsDataArrayToSetNotificationCreating.insert(NotificationDataToNotificationsCreate(name: user.name ?? "", day: dayToSetNotification, hour: hourNotifiction, minute: minuteNotification, notificationIdentifire: user.notificationIdentifire!), at: index)
                                    wasAdded = true
                                    break
                                } else {
                                    
                                    notificationsDataArrayToSetNotificationCreating.append(NotificationDataToNotificationsCreate(name: user.name ?? "", day: dayToSetNotification, hour: hourNotifiction, minute: minuteNotification, notificationIdentifire: user.notificationIdentifire!))
                                    wasAdded = true
                                    break
                                }
                                
                            }
                        }
                        
                        
                        if !wasAdded {
                            notificationsDataArrayToSetNotificationCreating.append(NotificationDataToNotificationsCreate(name: user.name ?? "", day: dayToSetNotification, hour: hourNotifiction, minute: minuteNotification, notificationIdentifire: user.notificationIdentifire!))
                        }
                        limitControl += 1
                        if limitControl == 60 {
                            break
                        }
                    }
                    
                }
                if limitControl == 60 {
                    break
                }
                dayInDatabase = dayInDatabase + 1 == 8 ? 1 : dayInDatabase + 1
                
            }
            // limits to 60 notifications
            while notificationsDataArrayToSetNotificationCreating.count > 60 {
                notificationsDataArrayToSetNotificationCreating.removeLast()
            }
            limitControl = 0
            
            if indexUser == users.count - 1 {
                createScheduleNotifications(notificationCenter: notificationCenter, notificationsData: notificationsDataArrayToSetNotificationCreating)
            }
        }
    }
    
    
    
    //create and add notifications
    
    private func createScheduleNotifications(notificationCenter: Notifications, notificationsData: [NotificationDataToNotificationsCreate]) {
        //    DispatchQueue.main.async {
        
        //create actions categories
        notificationCenter.createTimeToDrinkNotificationCategory(with: self.currentUser.notificationIdentifire!)
        
        notificationCenter.notificationCenter.removeAllPendingNotificationRequests()
        
      //  notificationCenter.testNotification(timeInterval: 5)
        
        
        
        for (index, notification) in notificationsData.enumerated() {
            
            notificationCenter.createScheduleNotification(title: AppTexts.firstGreetingWord + (notification.name) + "!", body: getNotificationBodyText(), categoryIdentifier: notification.notificationIdentifire, threadIdentifier: notification.notificationIdentifire, weekDay: notification.day, hour: notification.hour, minute: notification.minute, isLast: index == notificationsData.count - 1) {
                
            }
            // if we create last notification time in last day we call okActionNotificationSubsettingsMenu, wich clouses setinngs menu or only notification subsettings menu
            
        }
    }
    
     private func getNotificationBodyText() -> String {
        
        enum NotificationBodyTextType: Int, CaseIterable {
            case firstText, secondText, thirdText
        }
        
        let firstTypeText = AppTexts.firstTypeTextNotificationBody
        let secondTypeText = AppTexts.secondTypeTextNotificationBody
        let thirdTypeText = AppTexts.thirdTypeTextNotificationBody
        
        let randomValue = Int.random(in: 0 ..< NotificationBodyTextType.allCases.count)
        guard let randomTextType = NotificationBodyTextType.init(rawValue: randomValue) else {
            return firstTypeText
        }
        
        switch randomTextType {
        case .firstText:
            return firstTypeText
        case .secondText:
            return secondTypeText
        case .thirdText:
            return thirdTypeText
        }
    }
    
}

