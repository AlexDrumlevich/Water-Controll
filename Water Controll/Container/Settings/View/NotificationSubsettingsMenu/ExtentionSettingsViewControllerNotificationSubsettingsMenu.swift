//
//  ExtentionSettingsViewControllerNotificationSubsettingsMenu.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 13.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit


extension SettingsViewController {
    
    //create and add NotificationSubsettingsMenu
    func showNotificationSubsettingsMenu() {
        print( "showNotificationSubsettingsMenu was called" )
        
        //notifications setup
        guard currentUser.notifications as? NSMutableOrderedSet != nil else {
            print("can`t cast to NSMutableOrderedSet in func showNotificationSubsettingsMenu")
            return
        }
        notifications = currentUser.notifications as? NSMutableOrderedSet
        translateNotificationsFromNotificationClassToNotificationStracture()
        setupNotificationCenter()
    }
    
    
    //translate notification to structure
    //for use structure and have posibilities to cancel changes
    func translateNotificationsFromNotificationClassToNotificationStracture() {
        notificationsStracture = []
        
        for item in notifications {
            guard item as? Notificaton != nil else {
                print("can`t cast to Notificaton in  func translateNotificationsFromNotificationClassToNotificationStracture")
                return
            }
            
            let notification = item as! Notificaton
            
            //get time array for needed day
            let notificationsTime = notification.notificationsTime?.mutableCopy() as? NSMutableOrderedSet
            
            //check to nil
            guard notificationsTime != nil else {
                print("can`t get notifications time in func setupNotificationsTime file translateNotificationsFromNotificationClassToNotificationStracture")
                return
            }
            var timeArray = [Int16]()
            
            for  notificationTime in notificationsTime! {
                guard (notificationTime as? NotificationsTime) != nil else {
                    print("can`t cast to  NotificationsTime in func setupNotificationsTime file translateNotificationsFromNotificationClassToNotificationStracture")
                    return
                }
                
                
                timeArray.append((notificationTime as! NotificationsTime).notificationTime)
                print(timeArray)
            }
            
            notificationsStracture.append(NotificationsStructure(isActive: notification.isActive, isCommon: notification.isCommon, name: notification.name, start: notification.start, stop: notification.stop, times: notification.times, notificationsTimeADay: timeArray))
            
        }
    }
    
    //translate notification structure to class object for save context
    func translateNotificationsFromNotificationStructureToNotificationClass() {
        
        for (itemNumber, item) in notifications.enumerated() {
            guard  itemNumber <= notificationsStracture.count else {
                print("notifications and notificationsStracture not count items equaly in  func translateNotificationsFromNotificationStructureToNotificationClass")
                return
            }
            guard item as? Notificaton != nil else {
                print("can`t cast to Notificaton in  func translateNotificationsFromNotificationStructureToNotificationClass")
                return
            }
            let notification = item as! Notificaton
            let notificationStructureItem = notificationsStracture[itemNumber]
            
            guard notificationStructureItem.isActive != nil, notificationStructureItem.isCommon != nil, notificationStructureItem.start != nil, notificationStructureItem.stop != nil, notificationStructureItem.times != nil else {
                print("nil where it can`t be nilin  func translateNotificationsFromNotificationStructureToNotificationClass")
                return
            }
            notification.isActive = notificationStructureItem.isActive!
            notification.isCommon = notificationStructureItem.isCommon!
            notification.start = notificationStructureItem.start!
            notification.stop = notificationStructureItem.stop!
            notification.times = notificationStructureItem.times!
            
            let isLast = itemNumber == notifications.count - 1
            //translate notifications time
            DispatchQueue.main.async {
                    // setup notifictions time in notification of 1 day
                    //if we have last notification - we send a flag about it
                self.settingsViewControllerComplitionActions(.setupNotificationsTime(notification, notificationStructureItem, isLast))
            }
            
            
        }
    }
    
    //we call this method if we can send notifications
    func createTableViewNotificationSubsettingsMenu() {
        //create table view
        DispatchQueue.main.async {
            //hidden buttons
            self.hiddenButtons(buttons: [self.cancelButton], isHidden: self.settingsMode == .newUser || self.settingsMode == .firstUser)
            self.hiddenButtons(buttons: [self.okButton], isHidden: false)
            self.buttonsEnable(buttons: [self.cancelButton], isEnable: true)
            self.hiddenButtons(buttons: [self.plusButton, self.backButton, self.deleteButton, self.leftButton, self.rightButton], isHidden: true)
            
            self.tableViewMainSettings.isHidden = true
            self.isBlinkings = Array(repeating: false, count: 8)
            self.notificationSubsettingsMenu = UITableView()
            self.notificationSubsettingsMenu.tag = 1
            self.notificationSubsettingsMenu.delegate = self
            self.notificationSubsettingsMenu.dataSource = self
            // lines between cells
            self.notificationSubsettingsMenu.separatorStyle = .singleLine
            self.notificationSubsettingsMenu.separatorColor = #colorLiteral(red: 0.1640408039, green: 0.2041007578, blue: 1, alpha: 1)
            //background for tableView
            self.notificationSubsettingsMenu.backgroundColor = UIColor(displayP3Red: 248, green: 248, blue: 255, alpha: 0.4)
            
            self.notificationSubsettingsMenu.layer.cornerRadius = 10
            self.notificationSubsettingsMenu.clipsToBounds = true
            
            //set header view
            self.setHeaderView()
            
            //register cell
            self.notificationSubsettingsMenu.register(NotificationSubsettingsMenuCell.self, forCellReuseIdentifier: NotificationSubsettingsMenuCell.cellID)
            // add table view into view
            self.view.addSubview(self.notificationSubsettingsMenu)
            self.setupNotificationSubsettingsMenuConstraints()
            //avalibility controll`s animation  in cells
            if self.currentUser.volumeType == "oz" {
                self.isAmStopTime = [Bool]()
                self.isAmStartTime = [Bool]()
            }
            
         
        }
        
    }
    
    private func setHeaderView() {
        
        let label = UILabel()
        //set text settings
        label.textAlignment = .center

        label.font = UIFont(name: "AmericanTypewriter", size: view.bounds.height / 30)
        label.textColor = .purple//#colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = AppTexts.notificationsAppTexts
        
        notificationSubsettingsMenu.tableHeaderView = label
        notificationSubsettingsMenu.tableHeaderView?.bounds.size.height = view.bounds.height / 20
        notificationSubsettingsMenu.tableHeaderView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
        /*
        
        label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 0
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
                    label.topAnchor.constraint(equalTo: topAnchor),
                    label.bottomAnchor.constraint(equalTo: bottomAnchor),
                    ])
            }

            func configure(text: String) {
                label.text = text
            }
*/
        
    
    
    // when the user tapped ok button
    //we call these method in complition handler of method create shadule notification, when will create last notification
    func okActionNotificationSubsettingsMenu() {
      
     
            self.deleteNotificationSubsettingsMenu()
            
            if self.settingsMode == .newUser || self.settingsMode == .firstUser || self.settingsMode == .needToSetupVolumeSettings || self.settingsMode == .needToSetupNotificationSettingsOnly {
                self.settingsViewControllerComplitionActions(.closeSettingsViewContainer)
                
            } else {
                self.settingsMode = .waitAction
                   DispatchQueue.main.async {
                self.hiddenButtons(buttons: [self.okButton, self.cancelButton], isHidden: true)
                // hiddenButtons(buttons: [deleteButton], isHidden: false)
                self.hiddenButtons(buttons: [self.plusButton, self.backButton], isHidden: false)
                self.hiddenButtons(buttons: [self.leftButton, self.rightButton], isHidden: self.isSinglUser)
            }
        }
        
    }
        
        
    //delete and add NotificationSubsettingsMenu
    func deleteNotificationSubsettingsMenu() {
        
        guard notificationSubsettingsMenu != nil else {return}
       
        DispatchQueue.main.async {
            self.tableViewMainSettings.isHidden = false
        }
           
            self.isAmStopTime = nil
            self.isAmStartTime = nil
            DispatchQueue.main.async {
            self.cancelButton.isHidden = true
            self.okButton.isHidden = true
            self.notificationSubsettingsMenu.delegate = nil
            self.notificationSubsettingsMenu.dataSource = nil
            self.notificationSubsettingsMenu.removeFromSuperview()
            self.notificationSubsettingsMenu = nil
            }
            self.notifications = nil
            self.notificationsStracture = nil
            self.isAmStartTime = nil
            self.isAmStopTime = nil
            self.notificationCenter = nil
            self.isBlinkings = nil
            print("NotificationSubsettingsMenu delited")
        
        
    }
    
    
    //setup constraints
    private func setupNotificationSubsettingsMenuConstraints() {
        
        notificationSubsettingsMenu.translatesAutoresizingMaskIntoConstraints = false
        notificationSubsettingsMenu.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        notificationSubsettingsMenu.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -20).isActive = true
        
        if isVertical {
            notificationSubsettingsMenu.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.5).isActive = true
            notificationSubsettingsMenu.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
        } else {
            notificationSubsettingsMenu.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
            notificationSubsettingsMenu.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    
    //call this method from cellForRowAt indexPath in ExtentionSettingsViewControllerTableviewDelegates
    func setupNotificationSettingsTableViewCells(cell: NotificationSubsettingsMenuCell, indexPath: IndexPath) -> NotificationSubsettingsMenuCell {
        
        clearCellForUseQueueCells(views: cell.subviews)
        cell.isGeneralCell = indexPath.section == 0
        //get curent notification
        
        let notification = notificationsStracture[indexPath.section]
        
        /*
        //additional check that current notification equal current cell
        let notificationName = currentUser.volumeType == "oz" ? NotificationSettingsTableViewCellTypeSundayFirst(rawValue: indexPath.section)?.notificationName: NotificationSettingsTableViewCellTypeMondayFirst(rawValue: indexPath.section)?.notificationName//.sectionTitle
        if notification.name != notificationName, let notifications = notificationsStracture {
            for item in notifications {
                
                
                let notificationName = currentUser.volumeType == "oz" ? NotificationSettingsTableViewCellTypeSundayFirst(rawValue: indexPath.section)?.notificationName : NotificationSettingsTableViewCellTypeMondayFirst(rawValue: indexPath.section)?.notificationName
                if item.name == notificationName {
                    notification = item
                    break
                }
            }
        }
        */
        
        //50: 20 - 2 constraints into view, 45 - 9 constraints between elements inside cell + 5 as a precaution; / 6 - 6 elements in cell
        let itemWidth = isVertical ? (view.bounds.height) / 12 : (view.bounds.width - 70) / 6
        
        //setup cells
        
       // cell.setupCell(withFirstTypeMondy: NotificationSettingsTableViewCellTypeMondayFirst(rawValue: indexPath.section)!, withFirstTypeSunday: NotificationSettingsTableViewCellTypeSundayFirst (rawValue: indexPath.section)!, currentTypeMonday: currentUser.volumeType != "oz", itemWidth: itemWidth)
        let isGeneral = currentUser.volumeType == "oz" ? NotificationSettingsTableViewCellTypeSundayFirst(rawValue: indexPath.section)! == .generalSettings ? true : false : NotificationSettingsTableViewCellTypeMondayFirst(rawValue: indexPath.section)! == .generalSettings ? true : false
        
        cell.setupCell(withTag: indexPath.section, isGeneral:
            isGeneral, itemWidth: itemWidth)
 
        // notification availability
        cell.segmentedControllAvailabilityNotification.selectedSegmentIndex = notification.isActive ? 1 : 0
        
        // common settings
        cell.segmentedControllCommonSettings.selectedSegmentIndex = notification.isCommon ? 0 : 1
        
        //hide if off or (if common settings exept general)
        if notification.isActive == false || notification.isCommon == true && !cell.isGeneralCell {// notification.name != NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle
            hideViews(views: [cell.lessTimesButton, cell.timesRepeatCountLabel,  cell.moreTimesButton, cell.extentionSetupNotificationTimesADayButton, cell.startTimeLabel, cell.startSlider, cell.startAmPmLabel, cell.stopTimeLabel,  cell.stopAmPmLabel, cell.stopTimeSlider, cell.repeatImageView, cell.timesADayLabel, cell.startLabel, cell.stopLabel])
        }
        
        //repeat count label
        cell.timesRepeatCountLabel.text = String(notification.times!)
        
        
        // time and am/pm labels
        setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: cell.startTimeLabel, amPmLabel: cell.startAmPmLabel, time: notification.start)
        setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: cell.stopTimeLabel, amPmLabel: cell.stopAmPmLabel, time: notification.stop)
        
        //set value in sliders
        cell.startSlider.minimumValue = 0
        cell.startSlider.maximumValue = 1425
        cell.stopTimeSlider.minimumValue = -20
        cell.stopTimeSlider.maximumValue = 1430
        cell.startSlider.setValue(Float(notification.start), animated: true)
        cell.stopTimeSlider.setValue(Float(notification.stop), animated: true)
        
        //limit notifications time in a day
        cell.lessTimesButton.isEnabled = notification.times! > 2
        if  cell.lessTimesButton.isEnabled {
            cell.lessTimesButton.alpha = 1
        } else {
            cell.lessTimesButton.alpha = 0.2
        }
        cell.moreTimesButton.isEnabled = checkMaxTimesLimit(of: notification)
        if  cell.moreTimesButton.isEnabled {
            cell.moreTimesButton.alpha = 1
        } else {
            cell.moreTimesButton.alpha = 0.2
        }
        //font settings
        configurateFontForSegmentedControllers(for: cell.segmentedControllCommonSettings)
        configurateFontForSegmentedControllers(for: cell.segmentedControllAvailabilityNotification)
        //configurateFontForSegmentedControllers(for: cell.startTimeSegmentedControl)
        // configurateFontForSegmentedControllers(for: cell.stopTimeSegmentedControl)
        
        //add targets
        cell.segmentedControllCommonSettings.addTarget(self, action: #selector( segmentedControllCommonSettingsAction), for: .valueChanged)
        
        cell.segmentedControllAvailabilityNotification.addTarget(self, action: #selector( segmentedControllAvailabilityNotificationAction), for: .valueChanged)
        
        cell.lessTimesButton.addTarget(self, action: #selector(lessTimesButtonAction), for: .touchUpInside)
        
        cell.moreTimesButton.addTarget(self, action: #selector(moreTimesButtonAction), for: .touchUpInside)
        
        // cell.startTimeSegmentedControl.addTarget(self, action: #selector(startTimeSegmentedControlAction), for: .valueChanged)
        
        cell.startSlider.addTarget(self, action: #selector(startSliderAction), for: .valueChanged)
        
        // cell.stopTimeSegmentedControl.addTarget(self, action: #selector(stopTimeSegmentedControlAction), for: .valueChanged)
        
        cell.stopTimeSlider.addTarget(self, action: #selector(stopSliderAction), for: .valueChanged)
        
        cell.extentionSetupNotificationTimesADayButton.addTarget(self, action: #selector(extentionSetupNotificationTimesADayButtonAction), for: .touchUpInside)
        
        return cell
        
    }
    
    private func clearCellForUseQueueCells(views: [UIView?]) {
          for viewItem in views {
              if viewItem != nil {
                  viewItem?.removeFromSuperview()
              }
          }
      }
    
    //setup  time and am/pm labels
    private func setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: UILabel, amPmLabel: UILabel, time: Int16) {
        
        
        // 12h format
        if currentUser.volumeType == "oz" {
            
            if time < 720 {
                timeLabel.text = ((time / 60) < 10 ? (time / 60) == 0 ? "12" : "0" + String(time / 60) : String(time / 60))  + " : " + (time % 60 < 10 ? "0" + String(time % 60) : String(time % 60))
                amPmLabel.text = "am"
            } else {
                let timeForPm = time - 720
                timeLabel.text = ((timeForPm / 60) < 10 ? (timeForPm / 60) == 0 ? "12" : "0" + String(timeForPm / 60) : String(timeForPm / 60))  + " : " + (timeForPm % 60 < 10 ? "0" + String(timeForPm % 60) : String(timeForPm % 60))
                amPmLabel.text = "pm"
            }
            
            
            //24h format
        } else {
            timeLabel.text = ((time / 60) < 10 ? "0" + String(time / 60) : String(time / 60))  + " : " + (time % 60 < 10 ? "0" + String(time % 60) : String(time % 60))
            amPmLabel.isHidden = true
            
        }
    }
    
    
    
    //hide views methid
    private func hideViews(views: [UIView]) {
        for view in views {
            view.isHidden = true
        }
    }
    
    private func checkMaxTimesLimit(of notification: NotificationsStructure) -> Bool {
        let notificationActiveTime = notification.stop <= notification.start ? notification.stop + 1440 - notification.start : notification.stop - notification.start
        return notification.times < (notificationActiveTime / 15) + 1
    }
    
    private func setupMaxNotificationsTimesADay(of notification: NotificationsStructure) -> Int16 {
        let notificationActiveTime = notification.stop <= notification.start ? notification.stop + 1440 - notification.start : notification.stop - notification.start
        return (notificationActiveTime / 15) + 1
    }
    
    //call this method from heightForRowAt indexPath in ExtentionSettingsViewControllerTablevieDataSourse
    func setupCellHeight(indexPath: IndexPath) -> CGFloat {
        guard notificationsStracture!.count >= indexPath.section + 1 else {
            print("can`t get notification in setupCellHeight")
            return 0
        }
        let currentNotification = notificationsStracture[indexPath.section]
        if currentNotification.isActive! && !currentNotification.isCommon! || indexPath.section == 0 && currentNotification.isActive!{//currentNotification.name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle ?? "Common" && currentNotification.isActive! {
            if isVertical {
              return ((view.bounds.height) / 12) * 3 + 90
            } else {
                return ((view.bounds.width - 50) / 6) * 3 + 90
            }
        } else {
            return isVertical ? ((view.bounds.height) / 12) : ((view.bounds.width - 50) / 6)
        }
    }
    
    
    
    //MARK: setup notifications time in notification for all day
    //we call this method when we change notification times per day or start/stop time
    //first time notifictions time a day were created when we create a user
    private func setupNotificationsTime(for dayNotification: NotificationsStructure) -> [Int16] {
        
        var timeArray = [Int16]()
        
        for itemNumber in 0..<Int(dayNotification.times!) {
            //setup notification time for notificationsmin one day
            if itemNumber == 0 {
                timeArray.append(dayNotification.start!)
            } else if itemNumber == dayNotification.times! - 1 {
                timeArray.append(dayNotification.stop!)
            } else {
                let activeTime = dayNotification.stop <= dayNotification.start ? dayNotification.stop! + 1440 - dayNotification.start! : dayNotification.stop - dayNotification.start
                let oneTimePart = activeTime / (dayNotification.times - 1)
                let timePoint = oneTimePart * Int16(itemNumber)
                let roundedTimePoint = timePoint / 15 * 15
                let resultTime = dayNotification.start + roundedTimePoint
                timeArray.append(resultTime <= 1440 ? resultTime : resultTime - 1440)
            }
        }
        return timeArray
    }
    
    
    //next Day Label Blinks
    // we call method from cellForRowAt indexPath and when am/pm time sliders change
    
    func setupBlinkingStopLabel(isBlinkin: Bool, sectionNumber: Int, label: UILabel? = nil) {
        
        guard isBlinkings != nil else {
            print("isBlinking array is nil in func setupIsBlinkingStopLabel")
            return
        }
        guard isBlinkings.count > sectionNumber else {
            print("isBlinking array less then sectionNumber in func setupIsBlinkingStopLabel")
            return
        }
        
        var stopLabel = label
        if stopLabel == nil {
            guard let labelFromTable = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sectionNumber)) as? NotificationSubsettingsMenuCell)?.stopLabel else {
                print("can`t get stop label in func nextDayLabelBlinksAction")
                return
            }
            stopLabel = labelFromTable
        }
        
        var nextDay = "Next day:"
        if currentUser.volumeType == "oz" {
            if sectionNumber == NotificationSettingsTableViewCellTypeSundayFirst.allCases.count - 1 {
                nextDay = NotificationSettingsTableViewCellTypeSundayFirst(rawValue: 1)?.sectionTitle ?? "Next day:"
            } else {
                nextDay = sectionNumber == 0 ? "Next day:" : NotificationSettingsTableViewCellTypeSundayFirst(rawValue: sectionNumber + 1)?.sectionTitle ?? "Next day:"
            }
        } else {
            if sectionNumber == NotificationSettingsTableViewCellTypeMondayFirst.allCases.count - 1 {
                nextDay = NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 1)?.sectionTitle ?? "Next day:"
            } else {
                nextDay = sectionNumber == 0 ? "Next day:" : NotificationSettingsTableViewCellTypeMondayFirst(rawValue: sectionNumber + 1)?.sectionTitle ?? "Next day:"
            }
        }
        if label != nil {
            if isBlinkin {
                isBlinkings[sectionNumber] = true
                nextDayLabelBlinksAction(sectionNumber: sectionNumber, nextDay: nextDay, label: stopLabel!)
            } else {
                isBlinkings[sectionNumber] = false
            }
        } else {
            if !isBlinkings[sectionNumber] && isBlinkin {
                isBlinkings[sectionNumber] = true
                nextDayLabelBlinksAction(sectionNumber: sectionNumber, nextDay: nextDay, label: stopLabel!)
               
            } else if !isBlinkin {
                isBlinkings[sectionNumber] = false
             
            }
        }
    }
    
    private func nextDayLabelBlinksAction(sectionNumber: Int, nextDay: String, label: UILabel?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            guard let isBlinkings = self.isBlinkings, label != nil else {
                return
            }
            label?.text = label?.text == "Stop:" ? nextDay : "Stop:"
            if isBlinkings[sectionNumber] {
                self.nextDayLabelBlinksAction(sectionNumber: sectionNumber, nextDay: nextDay, label: label)
            } else {
                label?.text = "Stop:"
            }
        }
    }
    
    
    
    //MARK: implementation actions
    
    // Availability Notification Action
    @objc func segmentedControllAvailabilityNotificationAction(sender: UISegmentedControl) {
        configurateFontForSegmentedControllers(for: sender)
        guard notificationsStracture.count > sender.tag else {
            print("can`t get notification in segmentedControllAvailabilityNotificationAction")
            return
        }
        
        
        notificationsStracture[sender.tag].isActive = !notificationsStracture[sender.tag].isActive
        
        if sender.tag == 0 {//notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
            for (itemNumber, notification) in notificationsStracture.enumerated() {
                
                if notification.isCommon! {
                    notificationsStracture[itemNumber].isActive = notificationsStracture[sender.tag].isActive
                }
            }
        }
        notificationSubsettingsMenu.reloadData()
    }
    
    
    // common settings action
    @objc func segmentedControllCommonSettingsAction(sender: UISegmentedControl) {
        configurateFontForSegmentedControllers(for: sender)
        guard notificationsStracture.count > sender.tag else {
            print("can`t get notification in segmentedControllCommonSettingsAction")
            return
        }
        
        notificationsStracture[sender.tag].isCommon = !notificationsStracture[sender.tag].isCommon
        if notificationsStracture[sender.tag].isCommon {
            let commonNotification = notificationsStracture[NotificationSettingsTableViewCellTypeMondayFirst.generalSettings.rawValue]
            notificationsStracture[sender.tag].isActive = commonNotification.isActive
            notificationsStracture[sender.tag].start = commonNotification.start
            notificationsStracture[sender.tag].stop = commonNotification.stop
            notificationsStracture[sender.tag].times = commonNotification.times
            notificationsStracture[sender.tag].notificationsTimeADay = commonNotification.notificationsTimeADay
        } else {
            //blinking stop label
            setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
        }
        notificationSubsettingsMenu.reloadData()
    }
    
    
    //less repeat times
    @objc func lessTimesButtonAction(sender: UIButton) {
        guard notificationsStracture.count > sender.tag else {
            print("can`t get notification in segmentedControllAvailabilityNotificationAction")
            return
        }
        
        notificationsStracture[sender.tag].times -= 1
        notificationsStracture[sender.tag].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[sender.tag])
        if sender.tag == 0 {//notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
            for (itemNumber, item) in notificationsStracture.enumerated() {
                if item.isCommon {
                    notificationsStracture[itemNumber].times = notificationsStracture[sender.tag].times
                    notificationsStracture[itemNumber].notificationsTimeADay = notificationsStracture[sender.tag].notificationsTimeADay
                }
            }
        }
        notificationSubsettingsMenu.reloadData()
    }
    
    //more repeat times
    @objc func moreTimesButtonAction(sender: UIButton) {
        guard notificationsStracture.count > sender.tag else {
            print("can`t get notification in segmentedControllAvailabilityNotificationAction")
            return
        }
        
        notificationsStracture[sender.tag].times += 1
        notificationsStracture[sender.tag].notificationsTimeADay =  setupNotificationsTime(for: notificationsStracture[sender.tag])
        if sender.tag == 0 {//} notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
            for (itemNumber, item) in notificationsStracture.enumerated() {
                if item.isCommon {
                    notificationsStracture[itemNumber].times = notificationsStracture[sender.tag].times
                    notificationsStracture[itemNumber].notificationsTimeADay = notificationsStracture[sender.tag].notificationsTimeADay
                }
            }
        }
        notificationSubsettingsMenu.reloadData()
    }
    
    
    
    @objc func startSliderAction(sender: UISlider, event: UIEvent) {
        
        //try to get time and am/pm labels
        guard let timeLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.startTimeLabel, let amPmLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.startAmPmLabel else {
            print("can`t get time and am/pm labels in func timeSliderAction")
            return
        }
        
        //round to 15 min
        var startTimeSlider = Int16(round(sender.value / 15) * 15)
        guard let stopTime = notificationsStracture[sender.tag].stop, let startTime = notificationsStracture[sender.tag].start else { return }
        
        //stop last before first (not more 24 h)
        if startTimeSlider >= stopTime - 15 && startTime < stopTime  || startTimeSlider <= stopTime + 15 && startTime > stopTime {
            
            defer {
                startTimeSlider = startTime < stopTime ? stopTime - 15 : stopTime + 15
                
                notificationsStracture[sender.tag].start = startTimeSlider
                
                
                
                if sender.tag == 0 {
                    for i in 1 ..< notificationsStracture.count {
                        if notificationsStracture[i].isCommon {
                            notificationsStracture[i].start = startTimeSlider
                        }
                    }
                }
                sender.setValue(Float(startTimeSlider), animated: false)
                setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: startTimeSlider)
                // controlMaxNotificationTimes
                controlMaxNotificationTimes(senderIndex: sender.tag)
            }
            
            return
            //stop first before last (not more 24 h)
        }
        
        // touchEvent
        if let touchEvent = event.allTouches?.first {
            
            switch touchEvent.phase {
            case .cancelled, .ended:
                
                // controlMaxNotificationTimes
                controlMaxNotificationTimes(senderIndex: sender.tag)
                
                if sender.tag == 0 {
                    for i in 1 ..< notificationsStracture.count {
                        if notificationsStracture[i].isCommon {
                            notificationsStracture[i].start = startTimeSlider
                        }
                    }
                }
                
            default:
                break
            }
        }
        
        notificationsStracture[sender.tag].start = startTimeSlider
        setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: startTimeSlider)
        
    }
    
    
    @objc func stopSliderAction(sender: UISlider, event: UIEvent) {
        
        //try to get time and am/pm labels
        guard let timeLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.stopTimeLabel, let amPmLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.stopAmPmLabel else {
            print("can`t get time and am/pm labels in func timeSliderAction")
            return
        }
        
        guard let stopTime = notificationsStracture[sender.tag].stop, let startTime = notificationsStracture[sender.tag].start else { return }
        //round to 15 min
        var stopTimeSlider = Int16(round(sender.value / 15) * 15)
        
        
        
        //stop last before first (not more 24 h)
        if stopTimeSlider >= startTime - 15 && startTime > stopTime || stopTimeSlider <= startTime + 15 && stopTime > startTime {
            
            defer {
                stopTimeSlider = stopTime > startTime ? startTime + 15 : startTime - 15
                
                notificationsStracture[sender.tag].stop = stopTimeSlider
                if sender.tag == 0 {
                    for i in 1 ..< notificationsStracture.count {
                        if notificationsStracture[i].isCommon {
                            notificationsStracture[i].stop = stopTimeSlider
                        }
                    }
                }
                
                sender.setValue(Float(stopTimeSlider), animated: false)
                
                setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: stopTimeSlider)
                
                // controlMaxNotificationTimes
                controlMaxNotificationTimes(senderIndex: sender.tag)
                
                //blinking stop label
                if isBlinkings[sender.tag] != (stopTimeSlider <= startTime) {
                    setupBlinkingStopLabel(isBlinkin: stopTimeSlider <= startTime, sectionNumber: sender.tag)
                }
            }
            
            return
            //stop first before last (not more 24 h)
        }
        
        
        if sender.value < 0  {
            stopTimeSlider = 0
            if startTime != 1425 {
                timeLabel.text = "< back"
            } else {
                setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: stopTimeSlider)
            }
            
        } else if sender.value > 1425 {
            // setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, time: 1425)
            stopTimeSlider = 1425
            if startTime != 0 {
                timeLabel.text = "next day >"
            } else {
                setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: stopTimeSlider)
            }
            
        } else {
            setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: stopTimeSlider)
        }
        
        //blinking stop label
        if isBlinkings[sender.tag] != (stopTimeSlider <= startTime) {
            setupBlinkingStopLabel(isBlinkin: stopTimeSlider <= startTime, sectionNumber: sender.tag)
        }
        
        //touchEvent
        if let touchEvent = event.allTouches?.first {
            
            switch touchEvent.phase {
            case .cancelled, .ended:
                
                if sender.value < 0  {
                    stopTimeSlider = startTime == 1425 ? 0 : 1425
                    
                    if sender.tag == 0 {
                        for i in 1 ..< notificationsStracture.count {
                            if notificationsStracture[i].isCommon {
                                notificationsStracture[i].stop = stopTimeSlider
                            }
                        }
                    }
                    setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: stopTimeSlider)
                    
                    notificationsStracture[sender.tag].stop = stopTimeSlider
                    sender.setValue(Float(stopTimeSlider), animated: false)
                    
                    //blinking stop label
                    if isBlinkings[sender.tag] != (stopTimeSlider <= startTime) {
                        setupBlinkingStopLabel(isBlinkin: stopTimeSlider <= startTime, sectionNumber: sender.tag)
                    }
                    // controlMaxNotificationTimes
                    controlMaxNotificationTimes(senderIndex: sender.tag)
                    return
                    
                    
                } else if sender.value > 1425 {
                    stopTimeSlider = startTime == 0 ? 1425 : 0
                    
                    if sender.tag == 0 {
                        for i in 1 ..< notificationsStracture.count {
                            if notificationsStracture[i].isCommon {
                                notificationsStracture[i].stop = stopTimeSlider
                            }
                        }
                    }
                    
                    setTimeInTimeLabelNotificationSubsettingsMenu(timeLabel: timeLabel, amPmLabel: amPmLabel, time: stopTimeSlider)
                    
                    notificationsStracture[sender.tag].stop = stopTimeSlider
                    sender.setValue(Float(stopTimeSlider), animated: false)
                    
                    //blinking stop label
                    if isBlinkings[sender.tag] != (stopTimeSlider <= startTime) {
                        setupBlinkingStopLabel(isBlinkin: stopTimeSlider <= startTime, sectionNumber: sender.tag)
                    }
                    // controlMaxNotificationTimes
                    controlMaxNotificationTimes(senderIndex: sender.tag)
                    return
                } else {
                    //blinking stop label
                    if isBlinkings[sender.tag] != (stopTimeSlider <= startTime) {
                        setupBlinkingStopLabel(isBlinkin: stopTimeSlider <= startTime, sectionNumber: sender.tag)
                    }
                    // controlMaxNotificationTimes
                    controlMaxNotificationTimes(senderIndex: sender.tag)
                    
                    if sender.tag == 0 {
                        for i in 1 ..< notificationsStracture.count {
                            if notificationsStracture[i].isCommon {
                                notificationsStracture[i].stop = stopTimeSlider
                            }
                        }
                    }
                }
                
            default:
                break
            }
        }
        
        notificationsStracture[sender.tag].stop = stopTimeSlider
    }
    
    private func controlMaxNotificationTimes(senderIndex: Int) {
        if let plusButton = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: senderIndex)) as? NotificationSubsettingsMenuCell)?.moreTimesButton,  let minusButton = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: senderIndex)) as? NotificationSubsettingsMenuCell)?.lessTimesButton, let timesLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: senderIndex)) as? NotificationSubsettingsMenuCell)?.timesRepeatCountLabel {
            //disable more button if needed
            plusButton.isEnabled = checkMaxTimesLimit(of: notificationsStracture[senderIndex])
            if plusButton.isEnabled {
                plusButton.alpha = 1
            } else {
                plusButton.alpha = 0.2
            }
            minusButton.isEnabled = notificationsStracture[senderIndex].times > 2
            if minusButton.isEnabled {
                minusButton.alpha = 1
            } else {
                minusButton.alpha = 0.2
            }
            
            // setup max times a day if needed
            if notificationsStracture[senderIndex].times > setupMaxNotificationsTimesADay(of: notificationsStracture[senderIndex]) {
                notificationsStracture[senderIndex].times =  setupMaxNotificationsTimesADay(of: notificationsStracture[senderIndex])
                timesLabel.text = String(notificationsStracture[senderIndex].times)
            }
            
            //change notifications time
            notificationsStracture[senderIndex].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[senderIndex])
            
            if senderIndex == 0 {
                for i in 1..<notificationsStracture.count {
                    if notificationsStracture[i].isCommon == true {
                        notificationsStracture[i].notificationsTimeADay = notificationsStracture[0].notificationsTimeADay
                        notificationsStracture[i].times = notificationsStracture[0].times
                    }
                }
                
            }
        }
    }
    
    
    // extentionSetupNotificationTimesADayButtonAction
    //create NotificationsTimeSubsettingsMenu
    @objc func extentionSetupNotificationTimesADayButtonAction(sender: UIButton) {
        // check to get day notifications
        guard notificationsStracture.count > sender.tag else {
            print("can`t get notification in extentionSetupNotificationTimesADayButtonAction")
            return
        }
        
        //notifications time
        notificationForSetupNotificationsTime = notificationsStracture[sender.tag].notificationsTimeADay
        //current notifications day
        currentNotificationsTimeDaySender = sender.tag
        
        //create table view
        createNotificationsTimeSubsettingsMenu()
    }
    
    
    
    //configerated segmented controll`s font
    private func configurateFontForSegmentedControllers(for sender: UISegmentedControl) {
        let itemWidth = isVertical ? (view.bounds.height) / 12 :  (view.bounds.width - 50) / 6
        if let fontForSegmentedControlls = UIFont(name: "AmericanTypewriter", size:  itemWidth / 2.5) {
            if sender.accessibilityIdentifier == "segmentedControllAvailabilityNotification" {
                sender.setTitleTextAttributes([NSAttributedString.Key.font: fontForSegmentedControlls, NSAttributedString.Key.foregroundColor: sender.selectedSegmentIndex == 0 ? UIColor.red : #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)], for: .selected)
                sender.setTitleTextAttributes([NSAttributedString.Key.font: fontForSegmentedControlls, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
                
            } else {
                sender.setTitleTextAttributes([NSAttributedString.Key.font: fontForSegmentedControlls, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)], for: .selected)
                sender.setTitleTextAttributes([NSAttributedString.Key.font: fontForSegmentedControlls, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            }
        }
        
    }
    
}




//depricated functions

/*
 
 
 //cell setup
 //setup depend on 12h or 24 h format
 //if oz - 12 h, if liters - 24 h format
 if currentUser.volumeType == "oz" {
 //12 h = 720 min
 cell.startSlider.minimumValue = 0
 cell.startSlider.maximumValue = 705
 cell.stopTimeSlider.minimumValue = 0
 cell.stopTimeSlider.maximumValue = 705
 
 //append am - pm flags into arreys (do if we we dont do it early)
 if isAmStartTime.count < indexPath.section + 1 {
 isAmStartTime.append(notification.start! < 720)
 isAmStopTime.append(notification.stop! < 720)
 }
 
 
 
 //select am or pm segment
 cell.startTimeSegmentedControl.selectedSegmentIndex = isAmStartTime[indexPath.section] ? 0 : 1
 cell.stopTimeSegmentedControl.selectedSegmentIndex = isAmStopTime[indexPath.section] ? 0 : 1
 
 //translate from 24 h in 12 h format
 let startTime = isAmStartTime[indexPath.section] ? notification.start : notification.start - 720
 let stopTime = isAmStopTime[indexPath.section] ? notification.stop : notification.stop - 720
 
 //fill time labels
 let startHours = startTime! / 60 < 10 ? startTime! / 60 == 0 ? "12" : "0" + String(startTime! / 60) : String(startTime! / 60)
 let startMinutes = startTime! % 60 < 10 ? "0" + String(startTime! % 60) : String(startTime! % 60)
 cell.startTimeLabel.text = startHours + " : " + startMinutes
 //startMinutes  cell.startTimeLabel.text = startTime! / 60 < 10 ? startTime! / 60 == 0 ? "12" : "0" + String(startTime! / 60) : String(startTime! / 60) + " : " + startTime! % 60 < 10 ? "0" + String(startTime! % 60) : String(startTime! % 60)
 
 let stopHours = stopTime! / 60 < 10 ? stopTime! / 60 == 0 ? "12" : "0" + String(stopTime! / 60) : String(stopTime! / 60)
 let stopMinutes = stopTime! % 60 < 10 ? "0" + String(stopTime! % 60) : String(stopTime! % 60)
 cell.stopTimeLabel.text = stopHours + " : " + stopMinutes
 
 
 //setup sliders
 cell.startSlider.setValue(Float(startTime!), animated: true)
 cell.stopTimeSlider.setValue(Float(stopTime!), animated: true)
 
 } else {
 //if 24 h format
 
 //1440 min = 24 h
 cell.startSlider.minimumValue = 0
 cell.startSlider.maximumValue = 1425
 cell.stopTimeSlider.minimumValue = 0
 cell.stopTimeSlider.maximumValue = 1425
 
 //24 h formate in time label
 cell.startTimeLabel.text = ((notification.start! / 60) < 10 ? "0" + String(notification.start! / 60) : String(notification.start! / 60))  + " : " + (notification.start! % 60 < 10 ? "0" + String(notification.start! % 60) : String(notification.start! % 60))
 cell.stopTimeLabel.text = ((notification.stop! / 60) < 10 ? "0" + String(notification.stop! / 60) : String(notification.stop! / 60))  + " : " + (notification.stop! % 60 < 10 ? "0" + String(notification.stop! % 60) : String(notification.stop! % 60))
 
 //hide am-pm segmented controll
 hideViews(views: [cell.startTimeSegmentedControl, cell.stopTimeSegmentedControl])
 
 //setup sliders
 cell.startSlider.setValue(Float(notification.start!), animated: true)
 cell.stopTimeSlider.setValue(Float(notification.stop!), animated: true)
 }
 
 
 
 //start time am-pm
 @objc func startTimeSegmentedControlAction(sender: UISegmentedControl) {
 configurateFontForSegmentedControllers(for: sender)
 guard notificationsStracture.count > sender.tag else {
 print("can`t get notification in segmentedControllAvailabilityNotificationAction")
 return
 }
 
 isAmStartTime[sender.tag] = !isAmStartTime[sender.tag]
 notificationsStracture[sender.tag].start = isAmStartTime[sender.tag] ? notificationsStracture[sender.tag].start - 720 : notificationsStracture[sender.tag].start + 720
 //change notifications time
 
 notificationsStracture[sender.tag].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[sender.tag])
 //blinking stop label
 setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
 
 
 if notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
 
 for (index, item) in notificationsStracture.enumerated() {
 
 if item.isCommon {
 //change start time
 notificationsStracture[index].start = notificationsStracture[sender.tag].start
 //change notifications time
 notificationsStracture[index].notificationsTimeADay = notificationsStracture[sender.tag].notificationsTimeADay
 //check array
 if isAmStartTime.count >= index + 1 {
 //change am/pm
 isAmStartTime[index] = isAmStartTime[sender.tag]
 }
 }
 }
 }
 notificationSubsettingsMenu.reloadData()
 }
 
 
 
 //start time slider
 @objc func startSliderAction(sender: UISlider, event: UIEvent) {
 guard notificationsStracture.count > sender.tag else {
 print("can`t get notification in segmentedControllAvailabilityNotificationAction")
 return
 }
 
 //round to 15 min
 let roundedValue = round(sender.value / 15) * 15
 
 var timeForTimeLabel: Int16 = 0
 if isAmStartTime != nil {
 notificationsStracture[sender.tag].start = isAmStartTime[sender.tag] ? Int16(roundedValue) : Int16(roundedValue) + 720
 //change notifications time
 notificationsStracture[sender.tag].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[sender.tag])
 //blinking stop label
 setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
 
 timeForTimeLabel = notificationsStracture[sender.tag].start >= 720 ? notificationsStracture[sender.tag].start - 720 : notificationsStracture[sender.tag].start
 //get start time label to change it if we use slider
 if let startTimeLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.startTimeLabel {
 
 startTimeLabel.text = ((timeForTimeLabel / 60) < 10 ? (timeForTimeLabel / 60) == 0 ? "12" : "0" + String(timeForTimeLabel / 60) : String(timeForTimeLabel / 60))  + " : " + (timeForTimeLabel % 60 < 10 ? "0" + String(timeForTimeLabel % 60) : String(timeForTimeLabel % 60))
 
 
 }
 
 } else {
 notificationsStracture[sender.tag].start = Int16(roundedValue)
 //change notifications time
 notificationsStracture[sender.tag].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[sender.tag])
 //blinking stop label
 setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
 
 let timeForTimeLabel = notificationsStracture[sender.tag].start!
 //get start time label to change it if we use slider
 if let startTimeLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.startTimeLabel {
 
 startTimeLabel.text = ((timeForTimeLabel / 60) < 10 ? "0" + String(timeForTimeLabel / 60) : String(timeForTimeLabel / 60))  + " : " + (timeForTimeLabel % 60 < 10 ? "0" + String(timeForTimeLabel % 60) : String(timeForTimeLabel % 60))
 
 
 }
 }
 
 if let touchEvent = event.allTouches?.first {
 
 switch touchEvent.phase {
 case .cancelled, .ended:
 
 if let plusButton = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.moreTimesButton, let timesLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.timesRepeatCountLabel {
 //disable more button if needed
 plusButton.isEnabled = checkMaxTimesLimit(of: notificationsStracture[sender.tag])
 // setup max times a day if needed
 if notificationsStracture[sender.tag].times > setupMaxNotificationsTimesADay(of: notificationsStracture[sender.tag]) {
 notificationsStracture[sender.tag].times =  setupMaxNotificationsTimesADay(of: notificationsStracture[sender.tag])
 timesLabel.text = String(notificationsStracture[sender.tag].times)
 }
 notificationSubsettingsMenu.reloadData()
 }
 default:
 break
 }
 }
 
 //if curent notification - general
 if notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
 for (index, item) in notificationsStracture.enumerated() {
 if item.isCommon {
 notificationsStracture[index].start = notificationsStracture[sender.tag].start
 notificationsStracture[index].notificationsTimeADay = notificationsStracture[sender.tag].notificationsTimeADay
 }
 }
 }
 //   notificationSubsettingsMenu.reloadData()
 }
 
 
 //stop time am-pm
 @objc func stopTimeSegmentedControlAction(sender: UISegmentedControl) {
 configurateFontForSegmentedControllers(for: sender)
 guard notificationsStracture.count > sender.tag else {
 print("can`t get notification in segmentedControllAvailabilityNotificationAction")
 return
 }
 
 isAmStopTime[sender.tag] = !isAmStopTime[sender.tag]
 notificationsStracture[sender.tag].stop = isAmStopTime[sender.tag] ? notificationsStracture[sender.tag].stop - 720 : notificationsStracture[sender.tag].stop + 720
 //change notifications time
 notificationsStracture[sender.tag].notificationsTimeADay =  setupNotificationsTime(for: notificationsStracture[sender.tag])
 //blinking stop label
 setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
 
 if notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
 for (index, item) in notificationsStracture.enumerated() {
 
 if item.isCommon {
 notificationsStracture[index].stop = notificationsStracture[sender.tag].stop
 notificationsStracture[index].notificationsTimeADay = notificationsStracture[sender.tag].notificationsTimeADay
 notificationsStracture[index].times = notificationsStracture[sender.tag].times
 if isAmStopTime.count >= index + 1 {
 isAmStopTime[index] = isAmStopTime[sender.tag]
 }
 }
 }
 }
 notificationSubsettingsMenu.reloadData()
 }
 
 
 
 //stop time slider
 @objc func stopTimeSliderAction(sender: UISlider, event: UIEvent) {
 
 guard notificationsStracture.count > sender.tag else {
 print("can`t get notification in segmentedControllAvailabilityNotificationAction")
 return
 }
 
 let roundedValue = round(sender.value / 15) * 15
 
 var timeForTimeLabel: Int16 = 0
 if isAmStopTime != nil {
 notificationsStracture[sender.tag].stop = isAmStopTime[sender.tag] ? Int16(roundedValue) : Int16(roundedValue) + 720
 //change notifications time
 notificationsStracture[sender.tag].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[sender.tag])
 //blinking stop label
 setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
 
 timeForTimeLabel = notificationsStracture[sender.tag].stop >= 720 ? notificationsStracture[sender.tag].stop - 720 : notificationsStracture[sender.tag].stop
 if let stopTimeLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.stopTimeLabel {
 stopTimeLabel.text = ((timeForTimeLabel / 60) < 10 ? (timeForTimeLabel / 60) == 0 ? "12" : "0" + String(timeForTimeLabel / 60) : String(timeForTimeLabel / 60))  + " : " + (timeForTimeLabel % 60 < 10 ? "0" + String(timeForTimeLabel % 60) : String(timeForTimeLabel % 60))
 
 }
 } else {
 notificationsStracture[sender.tag].stop = Int16(roundedValue)
 //change notifications time
 notificationsStracture[sender.tag].notificationsTimeADay = setupNotificationsTime(for: notificationsStracture[sender.tag])
 //blinking stop label
 setupBlinkingStopLabel(isBlinkin: notificationsStracture[sender.tag].stop - notificationsStracture[sender.tag].start <= 0, sectionNumber: sender.tag)
 
 timeForTimeLabel = notificationsStracture[sender.tag].stop
 //get stop time label to change it if we use slder
 if let stopTimeLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.stopTimeLabel {
 
 stopTimeLabel.text = ((timeForTimeLabel / 60) < 10 ? "0" + String(timeForTimeLabel / 60) : String(timeForTimeLabel / 60))  + " : " + (timeForTimeLabel % 60 < 10 ? "0" + String(timeForTimeLabel % 60) : String(timeForTimeLabel % 60))
 
 }
 }
 
 if let touchEvent = event.allTouches?.first {
 
 switch touchEvent.phase {
 case .cancelled, .ended:
 
 if let plusButton = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.moreTimesButton, let timesLabel = (notificationSubsettingsMenu.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? NotificationSubsettingsMenuCell)?.timesRepeatCountLabel {
 //disable more button if needed
 plusButton.isEnabled = checkMaxTimesLimit(of: notificationsStracture[sender.tag])
 // setup max times a day if needed
 if notificationsStracture[sender.tag].times > setupMaxNotificationsTimesADay(of: notificationsStracture[sender.tag]) {
 notificationsStracture[sender.tag].times =  setupMaxNotificationsTimesADay(of: notificationsStracture[sender.tag])
 timesLabel.text = String(notificationsStracture[sender.tag].times)
 }
 notificationSubsettingsMenu.reloadData()
 }
 default:
 break
 }
 }
 // if is common
 if notificationsStracture[sender.tag].name == NotificationSettingsTableViewCellTypeMondayFirst(rawValue: 0)?.sectionTitle {
 for (index, item) in notificationsStracture.enumerated() {
 
 if item.isCommon {
 notificationsStracture[index].stop = notificationsStracture[sender.tag].stop
 notificationsStracture[index].notificationsTimeADay = notificationsStracture[sender.tag].notificationsTimeADay
 notificationsStracture[index].times = notificationsStracture[sender.tag].times
 }
 }
 }
 //  notificationSubsettingsMenu.reloadData()
 }
 
 
 
 
 */

