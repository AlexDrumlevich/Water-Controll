//
//  ContainerViewControllerCoreData.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 22.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation
import CoreData
extension ContainerViewController {
    
    //MARK: Local Data Base
    
    //get access controller from local database and if no one user - create new user
    func getAccesControllerFromLocalDataBase() {
        
        // get access controller
        let fetchRequestAccessController: NSFetchRequest<AccessController> = AccessController.fetchRequest()
        var accessControllers = [AccessController]()
        do {
            accessControllers = try contextDataBase.fetch(fetchRequestAccessController)
            if accessControllers.isEmpty {
                let access = AccessController(context: contextDataBase)
                access.currentDate = Date()
                access.premiumAccount = false
                access.bottelsAvailable = 1
                access.needTimesPourWaterToCallRateTheApp = needTimesPourWaterToCallRateMenu
                access.boundelAppRated = getCurrentAppVersion()
                accessController = access
            } else {
                accessController = accessControllers.first
                // change call rate the app conditions
                if accessController != nil {
                    if accessController?.boundelAppRated != "" && getCurrentAppVersion() != accessController?.boundelAppRated && getCurrentAppVersion() != "" {
                        accessController?.needTimesPourWaterToCallRateTheApp = needTimesPourWaterToCallRateMenu
                        accessController?.boundelAppRated = getCurrentAppVersion()
                        saveContextInLocalDataBase()
                    }
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getCurrentAppVersion () -> String {
        let bundle = Bundle.main
        let bundleVersionKey = kCFBundleVersionKey as String
        return bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String ?? ""
    }
    
    
    //get current user from local database and if no one user - create new user
    func getCurrentUsersFromLocalDataBase() {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            //get users from local data base
            users = try contextDataBase.fetch(fetchRequest)
            
            //if no any users - create new user and present SettingsViewController
            if users.isEmpty {
                let user = User(context: contextDataBase)
                user.identifire = UUID().uuidString
                user.notificationIdentifire = UUID().uuidString
                user.currentUser = true
                user.name = ""
                user.fullVolume = 0
                user.currentVolume = 0
                user.currentVolumeInBottle = 0
                user.isEmptyBottle = true
                user.isAutoFillBottleType = false
                currentUser = user
                users.append(currentUser)
                setupNotificationOfNewUser(user: currentUser)
                //present SettingsViewController if in data base was not any users
                //and pass thet we have the first user in our app
                presentSettingsViewController(with: .firstUser)
            } else {
                //update notifications
                self.updateNotifications()
                //if we some user - find current user amout them
                for user in users {
                    if user.currentUser {
                        currentUser = user
                        if currentUser.volumeType == nil {
                            presentSettingsViewController(with: .needToSetupVolumeSettings)
                        }
                        return
                    }
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    //we create new user in context and call method viewDidLoad() of settings VC with new user mode
    //we don`t save context here, only when user tapped ok button when take his name
    //so if the user push plus button and turn of the app, new user won`t create
    func createNewUser() {
        let user = User(context: contextDataBase)
        user.identifire = UUID().uuidString
        user.notificationIdentifire = UUID().uuidString
        user.name = ""
        user.currentVolume = 0
        user.fullVolume = 0
        user.currentVolumeInBottle = 0
        user.isEmptyBottle = true
        user.isAutoFillBottleType = false
        user.currentUser = true
        if currentUser != nil {
            currentUser.currentUser = false
        }
        currentUser = user
        setupNotificationOfNewUser(user: currentUser)
        users.append(currentUser)
        
       // clouseSettingsViewController()
        presentSettingsViewController(with: users.count == 1 ? .firstUser : .newUser)
        //settingsViewController.currentUser = currentUser
        //settingsViewController.isSinglUser = users.count < 2
        
        //if we create new user and we don`t have any anouter user, we send fist user to hide cancel button
      //  settingsViewController.settingsMode = users.count == 1 ? .firstUser : .newUser
        //settingsViewController.isSinglUser = users.count < 2
        
        //settingsViewController.updateSettingsViewController()
    }
    
    // setup notifications data
    func setupNotificationOfNewUser(user: User) {
        
        //in fit step we give NotificationSettingsTableViewCellTypeMondayFirst type and then change it if we`ll chouse oz volume type
        
        let notifications = currentUser.notifications?.mutableCopy() as? NSMutableOrderedSet
        for i in 0..<( NotificationSettingsTableViewCellTypeMondayFirst.allCases.count) {
            let notification = Notificaton(context: contextDataBase)
            notification.isActive = true
            notification.isCommon = true
            notification.name = NotificationSettingsTableViewCellTypeMondayFirst(rawValue: i)?.sectionTitle
            notification.start = 480
            notification.stop = 1320
            notification.times = 4
            
            //setup notifications time in notification
            let notificationsTime = notification.notificationsTime?.mutableCopy() as? NSMutableOrderedSet
            for i in 0..<notification.times {
                let notificationTime = NotificationsTime(context: contextDataBase)
                notificationTime.notification = notification
                if i == 0 {
                    notificationTime.notificationTime = notification.start
                } else if i == notification.times - 1 {
                    notificationTime.notificationTime = notification.stop
                } else {
                    notificationTime.notificationTime = notification.start + ((((notification.stop - notification.start) / (notification.times - 1) * Int16(i)) / 15) * 15)
                }
                notificationsTime?.add(notificationTime)
                
            }
            notification.notificationsTime = notificationsTime
            
            notification.user = user
            notifications?.add(notification)
        }
        user.notifications = notifications
    }
    
    
    //setup notifications time in notification from notification settings
    func setupNotificationsTime(in notification: Notificaton, from notificationStracture: NotificationsStructure, isLast: Bool, complitionAction: @escaping(() -> Void)) {
        
        guard let notificationsTimeFromNotificationStracture = notificationStracture.notificationsTimeADay else {
            print("notificationsTimeADay is nil in func setupNotificationsTime")
            return
        }
        let notificationsTime = notification.notificationsTime?.mutableCopy() as? NSMutableOrderedSet
        notificationsTime?.removeAllObjects()
        for i in 0 ..< notificationsTimeFromNotificationStracture.count {
            let notificationTime = NotificationsTime(context: contextDataBase)
            let time = notificationsTimeFromNotificationStracture[i]
            notificationTime.notificationTime = time
            notificationsTime?.add(notificationTime)
        }
        notification.notificationsTime = []
        notification.notificationsTime = notificationsTime
        
        if isLast {
            complitionAction()
        }
    }
    
    
    
    //delete user - from settings vc
    func deleteUser() {
        
        //1 remove user from array users
        
        for (itemNumber, user) in users.enumerated() {
            if user.identifire == currentUser.identifire {
                users.remove(at: itemNumber)
                //2 if there was last user - open settings vc to create new user
                if users.isEmpty {
                    
                    currentUser = nil
                    //delete user from context
                    contextDataBase.delete(user)
                    //save context with out deleted user
                    saveContextInLocalDataBase()
                    clouseSettingsViewController()
                    createNewUser()
                } else {
                    
                    //else - change current user and reload settings vc
                    user.currentUser = false
                    currentUser = itemNumber == users.count ? users[itemNumber - 1] : users[itemNumber]
                    currentUser.currentUser = true
                    //delete user from context
                    contextDataBase.delete(user)
                    //save context with out deleted user
                    saveContextInLocalDataBase()
                    presentSettingsViewController(with: .waitAction)
//                    settingsViewController.currentUser = currentUser
  //                  settingsViewController.settingsMode = .waitAction
//                    if users.count < 2 {
//                        settingsViewController.isSinglUser = true
//                    }
//                    settingsViewController.updateSettingsViewController()
                }
                
                return
            }
        }
    }
    
    //change user
    func changeUser(direction: ChangeUserDirection) {
        //close custom alerts if they are
        menuViewController.alertControllerCustom?.clouseAlert()
        
        
        guard users.count > 1 else { return }
        for (itemNumber, user) in users.enumerated() {
            if user.identifire == currentUser.identifire {
                
                var newCurrentUser: User?
                if direction == .next {
                    let newCurrentUserIndex = itemNumber + 1 < users.count ? itemNumber + 1 : 0
                    newCurrentUser = users[newCurrentUserIndex]
                } else if direction == .previous {
                    let newCurrentUserIndex = itemNumber - 1 >= 0 ? itemNumber - 1 : users.count - 1
                    newCurrentUser = users[newCurrentUserIndex]
                }
                
                guard newCurrentUser != nil else { return }
                user.currentUser = false
                newCurrentUser!.currentUser = true
                saveContextInLocalDataBase()
                currentUser = newCurrentUser
                if settingsViewController != nil {
                   
                    settingsViewController.currentUser = currentUser
                    settingsViewController.updateSettingsViewController()
                    
                }
                //change graph view
                if menuViewController.graphView != nil {
                    menuViewController.deleteGraphView()
                    menuViewController.createGraphView()
                }
                return
            }
        }
    }
    
    
    // add poure water data when user poured water and when we create new user and set volume data in method saveSettingsAndClouseSettingsViewControllerAndSubviews
    func addPourWaterData(wasPoured volume: Float, date: Date?, user: User) {
        
        // get array got water of current user
        guard let pourWaterDatas = user.gotWaters?.mutableCopy() as? NSMutableOrderedSet else {
            print("pourWaterDatas is nil in addPourWaterData")
            return
        }
        
        //if array isn,t empty we check last element and we add new volume to last element if we have the same date or create new element
        if pourWaterDatas.count > 0 {
            
            guard let gotWaterLastInDataBase = pourWaterDatas.lastObject as? GotWater else {
                print("can`t convert to GotWater in addPourWaterData")
                return
            }
            guard let lastDate = gotWaterLastInDataBase.data else {
                print("can`t get date in addPourWaterData")
                return
            }
            
            let calendar = Calendar.current
            
            let lastDay = calendar.component(.day, from: lastDate)
            let lastMonth = calendar.component(.month, from: lastDate)
            
            let currentDay = calendar.component(.day, from: Date())
            let currentMonth = calendar.component(.month, from: Date())
            
            
            if lastDay == currentDay && lastMonth == currentMonth {
                
                var tempararyGetVolume = gotWaterLastInDataBase.volumeGet + volume
                
                if !gotWaterLastInDataBase.isOzType {
                    tempararyGetVolume = round(1000 * tempararyGetVolume) / 1000
                    
                }
                gotWaterLastInDataBase.volumeGet = tempararyGetVolume
                
                gotWaterLastInDataBase.volumeTarget = user.fullVolume
                
                //if user change volume type
                if let currentVolumeType = user.volumeType {
                    let currentIsOz = currentVolumeType == "oz" ? true : false
                    
                    if gotWaterLastInDataBase.isOzType != currentIsOz {
                        //change volume type
                        gotWaterLastInDataBase.isOzType = currentIsOz
                        //translate got water volume if user change volume type
                        
                        if gotWaterLastInDataBase.volumeGet != 0 {
                            
                            //translate oz in liters if the user setuped volume in oz early
                            if !currentIsOz {
                                let volumeInLiters = gotWaterLastInDataBase.volumeGet / 33.81
                                if let roundedVolumeInLiter = Float(String(format: "%.2f", volumeInLiters)) {
                                    gotWaterLastInDataBase.volumeGet = roundedVolumeInLiter
                                    //set to current user in curren volme
                                    currentUser.currentVolume = roundedVolumeInLiter
                                } else {
                                    gotWaterLastInDataBase.volumeGet = 0
                                }
                                
                            } else {
                                //translate liter in oz if the user setuped volume in liters early
                                
                                let volumeInOz = Float(Int(gotWaterLastInDataBase.volumeGet * 33.81))
                                gotWaterLastInDataBase.volumeGet = volumeInOz
                                
                                //set to current user in curren volme
                                currentUser.currentVolume = volumeInOz
                            }
                        }
                    }
                }
                saveContextInLocalDataBase()
                
            } else {
                addNewElementInGotWaters(volume: volume, date: date, user: user)
            }
            
        } else {
            addNewElementInGotWaters(volume: volume, date: date, user: user)
        }
    }
    
    // add new element in gotWaters data in we don`t have any data in got water or we have new date (day, month) pour water
    
    private func addNewElementInGotWaters(volume: Float, date: Date?, user: User) {
        
        let newGotWaterElement = GotWater(context: contextDataBase)
        if date == nil {
            newGotWaterElement.data = Date()
        } else {
            newGotWaterElement.data = date
        }
        newGotWaterElement.volumeGet = volume
        newGotWaterElement.volumeTarget = user.fullVolume
        newGotWaterElement.user = user
        
        if user.volumeType != nil {
            newGotWaterElement.isOzType = user.volumeType! == "oz" ? true : false
        } else {
            newGotWaterElement.isOzType = true
        }
        
        let gotWaters = user.gotWaters?.mutableCopy() as? NSMutableOrderedSet
        gotWaters?.add(newGotWaterElement)
        user.gotWaters = gotWaters
        saveContextInLocalDataBase()
    }
    
    //get pour water data
    
    func getPoureWatersData() -> NSMutableOrderedSet? {
        
        let gotWaters = currentUser.gotWaters?.mutableCopy() as? NSMutableOrderedSet
        
        return gotWaters
        
    }
    
    // save context
    func saveContextInLocalDataBase()  {
        if contextDataBase.hasChanges {
            do {
                try contextDataBase.save()
            } catch let error as NSError {
                
                print(error.localizedDescription)
            }
        }
    }
    
    //add ad consent with out save
    func addAdConsentToDataBase(date: Date, text: String) {
        
        let adConsent = AdConsents(context: contextDataBase)
        adConsent.date = date
        adConsent.textOfConsent = text
    }
}
