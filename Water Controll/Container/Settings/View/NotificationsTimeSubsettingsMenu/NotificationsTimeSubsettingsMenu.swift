//
//  NotificationsTimeSubsettingsMenu.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 03.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    //we call this method from extentionSetupNotificationTimesADayButtonAction
    //create NotificationsTimeSubsettingsMenu
    func createNotificationsTimeSubsettingsMenu() {
        
        notificationSubsettingsMenu.isHidden = true
        notificationsTimeSubsettingsMenu = UITableView()
        notificationsTimeSubsettingsMenu.tag = 2
        notificationsTimeSubsettingsMenu.delegate = self
        notificationsTimeSubsettingsMenu.dataSource = self
        // lines between cells
        notificationsTimeSubsettingsMenu.separatorStyle = .singleLine
        notificationsTimeSubsettingsMenu.separatorColor = #colorLiteral(red: 0.1640408039, green: 0.2041007578, blue: 1, alpha: 1)
        //background tableView
        notificationsTimeSubsettingsMenu.backgroundColor = UIColor(displayP3Red: 248, green: 248, blue: 255, alpha: 0.4)
        //corner radius
        notificationsTimeSubsettingsMenu.layer.cornerRadius = 10
        notificationsTimeSubsettingsMenu.clipsToBounds = true
        
        //register cell
        notificationsTimeSubsettingsMenu.register(NotificationsTimeSubsettingsMenuCell.self, forCellReuseIdentifier: NotificationsTimeSubsettingsMenuCell.cellID)
        
        
        // add table view into view
        view.addSubview(notificationsTimeSubsettingsMenu)
        //setup constraints
        setupNotificationsTimeSubsettingsMenuConstraints()
        setupNotificationForNextDay()
    }
    
    //delete NotificationsTimeSubsettingsMenu
    func deleteNotificationsTimeSubsettingsMenu() {
    
        notificationSubsettingsMenu.isHidden = false
        notificationsTimeSubsettingsMenu.delegate = nil
        notificationsTimeSubsettingsMenu.dataSource = nil
        notificationsTimeSubsettingsMenu.removeFromSuperview()
        notificationsTimeSubsettingsMenu = nil
        notificationForSetupNotificationsTime = nil
        currentNotificationsTimeDaySender = nil
        isNextDay = nil
        
        print("NotificationsTimeSubsettingsMenu delited")
    }
    
    
    
    
    //setup constraints
    private func setupNotificationsTimeSubsettingsMenuConstraints() {
        
        notificationsTimeSubsettingsMenu.translatesAutoresizingMaskIntoConstraints = false
        notificationsTimeSubsettingsMenu.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        notificationsTimeSubsettingsMenu.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -20).isActive = true
        
        if isVertical {
            notificationsTimeSubsettingsMenu.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.5).isActive = true
            notificationsTimeSubsettingsMenu.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
        } else {
            notificationsTimeSubsettingsMenu.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
            notificationsTimeSubsettingsMenu.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        }
        
    }
    
    //ok Action
    func okActionInNotificationsTimeSubsettingsMenu() {
        notificationsStracture[currentNotificationsTimeDaySender].notificationsTimeADay = notificationForSetupNotificationsTime
        notificationsStracture[currentNotificationsTimeDaySender].start = notificationForSetupNotificationsTime.first
        notificationsStracture[currentNotificationsTimeDaySender].stop = notificationForSetupNotificationsTime.last
        if currentNotificationsTimeDaySender == 0 {
            for i in 1..<notificationsStracture.count {
                if notificationsStracture[i].isCommon {
                    notificationsStracture[i].start = notificationForSetupNotificationsTime.first
                    notificationsStracture[i].stop = notificationForSetupNotificationsTime.last
                    notificationsStracture[i].notificationsTimeADay = notificationForSetupNotificationsTime
                }
            }
        }
        deleteNotificationsTimeSubsettingsMenu()
        notificationSubsettingsMenu.reloadData()
    }
    
    
    
    //setup notificationForSetupNotificationsTime if we have next day notification
    //we add 24 h for next day notification
    func setupNotificationForNextDay() {
        isNextDay = Array(repeating: false, count: notificationForSetupNotificationsTime.count)
        
        for i in 0..<notificationForSetupNotificationsTime.count {
            if i != 0 && notificationForSetupNotificationsTime[i] < notificationForSetupNotificationsTime[i - 1] {
                for j in i..<notificationForSetupNotificationsTime.count {
                    isNextDay[j] = true
                }
                break
            }
        }
    }
    
    //count of rows in table view
    func numberOfRowsInTableViewNotificationsTimeADay() -> Int {
        //check to nil
        guard notificationForSetupNotificationsTime != nil else {
            print("notifitations time is nil in func setupsetupNotificationsTimeSubsettingsMenuCells")
            return 0
        }
       
        return notificationForSetupNotificationsTime.count
    }
    
    //title of section
    func setupSectionTitleInTableViewNotificationsTimeADay() -> String {
        return currentUser.volumeType == "oz" ? NotificationSettingsTableViewCellTypeSundayFirst(rawValue: currentNotificationsTimeDaySender)?.sectionTitle ?? "" :  NotificationSettingsTableViewCellTypeMondayFirst(rawValue: currentNotificationsTimeDaySender)?.sectionTitle ?? ""
    }
    
    //cell height
    func setupCellHideInTableViewNotificationsTimeADay() -> CGFloat {
        return isVertical ? CGFloat((view.bounds.width - 50) / 6) : CGFloat((view.bounds.width - 50) / 3)
    }
    
    
    
    //call this method from cellForRowAt indexPath in ExtentionSettingsViewControllerTableviewDelegates
    func setupNotificationsTimeSubsettingsMenuCells(cell: NotificationsTimeSubsettingsMenuCell, indexPath: IndexPath) -> NotificationsTimeSubsettingsMenuCell {
        
        //check to nil
        guard notificationForSetupNotificationsTime != nil else {
            print("notifitations time is nil in func setupsetupNotificationsTimeSubsettingsMenuCells")
            return cell
        }
        //check to have needed array`s element
        guard notificationForSetupNotificationsTime.count >= indexPath.row + 1 else {
            print("notifitations time less than needed in func setupsetupNotificationsTimeSubsettingsMenuCells")
            return cell
        }
    
        clearCellForUseQueueCells(views: [cell.nextDayLabel,  cell.amPmLabel, cell.notificationNumberLabel, cell.timeLabel, cell.timeSlider])
      
        
        let time = notificationForSetupNotificationsTime[indexPath.row]
        //item width
        let itemWidth = isVertical ? (view.bounds.height - 50) / 12 : (view.bounds.width - 50) / 6
        
        //setup cell
        cell.setupCell(itemWidth: itemWidth, rowNumber: indexPath.row)
        
        //notification number label
        cell.notificationNumberLabel.text = String(indexPath.row + 1)
        
        // time and am/pm labels and next day label
        setTimeInTimeLabel(timeLabel: cell.timeLabel, amPmLabel: cell.amPmLabel, nextDayLabel: cell.nextDayLabel, isNextDay: isNextDay[indexPath.row], time: time)
        
        
        
        //time slider
        cell.timeSlider.minimumValue = indexPath.row == 0 ? 0 : -20
        cell.timeSlider.maximumValue = indexPath.row == 0 ? 1425 : 1430
        cell.timeSlider.setValue(Float(time), animated: true)
        cell.timeSlider.addTarget(self, action: #selector(timeSliderAction), for: .valueChanged)
        
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
     func setTimeInTimeLabel(timeLabel: UILabel, amPmLabel: UILabel, nextDayLabel: UILabel, isNextDay: Bool, time: Int16) {
        
        
        // 12h format
        if isAmStartTime != nil {
            if time < 720 {
                timeLabel.text = ((time / 60) < 10 ? (time / 60) == 0 ? "12" : "0" + String(time / 60) : String(time / 60))  + " : " + (time % 60 < 10 ? "0" + String(time % 60) : String(time % 60))
                amPmLabel.text = "am"
            } else {
                let timeForPm = time - 720
                timeLabel.text = ((timeForPm / 60) < 10 ? (timeForPm / 60) == 0 ? "12" : "0" + String(timeForPm / 60) : String(timeForPm / 60))  + " : " + (time % 60 < 10 ? "0" + String(timeForPm % 60) : String(timeForPm % 60))
                amPmLabel.text = "pm"
                
            }
            //24h format
        } else {
            timeLabel.text = ((time / 60) < 10 ? "0" + String(time / 60) : String(time / 60))  + " : " + (time % 60 < 10 ? "0" + String(time % 60) : String(time % 60))
            amPmLabel.isHidden = true
        }
        nextDayLabel.text = isNextDay ? "Next day" : ""
        
    }
    
    
}


