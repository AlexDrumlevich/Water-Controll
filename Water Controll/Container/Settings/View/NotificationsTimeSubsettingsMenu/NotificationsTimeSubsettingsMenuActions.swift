//
//  NotificationsTimeSubsettingsMenuActions.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 12.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    //slider action
    @objc func timeSliderAction(sender: UISlider, event: UIEvent) {
        
        //try to get time and am/pm labels
        guard let timeLabel = (notificationsTimeSubsettingsMenu.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? NotificationsTimeSubsettingsMenuCell)?.timeLabel, let amPmLabel = (notificationsTimeSubsettingsMenu.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? NotificationsTimeSubsettingsMenuCell)?.amPmLabel, let nextDayLabel = (notificationsTimeSubsettingsMenu.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? NotificationsTimeSubsettingsMenuCell)?.nextDayLabel else {
            print("can`t get time and am/pm labels in func timeSliderAction")
            return
        }
        
        var time = notificationForSetupNotificationsTime[sender.tag]
        var previousTime = Int16(-30)
        var nextTime = Int16(3000)
        
        
        //get previous time if we don`t have first slider
        if sender.tag != 0 {
            previousTime = isNextDay[sender.tag - 1] ? notificationForSetupNotificationsTime[sender.tag - 1] + 1440 : notificationForSetupNotificationsTime[sender.tag - 1]
        }
        
        //get next time if we don`t have last slider
        if sender.tag != notificationForSetupNotificationsTime.count - 1 {
            nextTime = isNextDay[sender.tag + 1] ? notificationForSetupNotificationsTime[sender.tag + 1] + 1440 : notificationForSetupNotificationsTime[sender.tag + 1]
            
        }
        
        //round to 15 min
        //+1440 if needed
        let roundedTime = isNextDay[sender.tag] ? Int16(round(sender.value / 15) * 15) + 1440 : Int16(round(sender.value / 15) * 15)
        
        //-1440 if needed
        time = isNextDay[sender.tag] ? roundedTime - 1440 : roundedTime
        
        //stop before previousTime notification
        if roundedTime <= previousTime + 16 {
            time = previousTime + 15
            sender.setValue(Float(isNextDay[sender.tag] ? time - 1440 : time), animated: false)
            //set time in label
            setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: isNextDay[sender.tag] ? time - 1440 : time)
            //save time
            notificationForSetupNotificationsTime[sender.tag] = isNextDay[sender.tag] ? time - 1440 : time
            return
            //stop before nextTime notification
        } else if roundedTime >= nextTime - 16 {
            time = nextTime - 15
            
            sender.setValue(Float(isNextDay[sender.tag] ? time - 1440 : time), animated: false)
            //set time in label
            setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: isNextDay[sender.tag] ? time - 1440 : time)
            //save time
            notificationForSetupNotificationsTime[sender.tag] = isNextDay[sender.tag] ? time - 1440 : time
            return
            //stop before 0
        } else if roundedTime < 0 {
            time = 0
        }
            
            
            //stop last before first (not more 24 h)
        else if sender.tag == notificationForSetupNotificationsTime.count - 1 && time >= notificationForSetupNotificationsTime.first! - 16 && isNextDay.last! {
            time = notificationForSetupNotificationsTime.first! - 15
            notificationForSetupNotificationsTime[notificationForSetupNotificationsTime.count - 1] = time
            sender.setValue(Float(time), animated: false)
            setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: time)
            return
            //stop first before last (not more 24 h)
        } else if sender.tag == 0 && time <= notificationForSetupNotificationsTime.last! + 16 && isNextDay.last! {
            time = notificationForSetupNotificationsTime.last! + 15
            notificationForSetupNotificationsTime[0] = time
            sender.setValue(Float(time), animated: false)
            setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: time)
            return
        }
        
        
        if sender.value < 0  && isNextDay[sender.tag] {
            //setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, time: 0)
            notificationForSetupNotificationsTime[sender.tag] = 0
            timeLabel.text = "< back"
            
        } else if sender.value > 1425 && !isNextDay[sender.tag] {
            // setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, time: 1425)
            if sender.tag == notificationForSetupNotificationsTime.count - 1 && notificationForSetupNotificationsTime.first! == 0 {
                time = 1425
                notificationForSetupNotificationsTime[sender.tag] = time
                sender.setValue(Float(time), animated: false)
                setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: time)
            } else {
                notificationForSetupNotificationsTime[sender.tag] = 1425
                timeLabel.text = "next day >"
            }
        } else {
            //set time in label
            setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: time)
            //save time
            notificationForSetupNotificationsTime[sender.tag] = time
        }
        
        
        if let touchEvent = event.allTouches?.first {
            
            switch touchEvent.phase {
            case .cancelled, .ended:
                
                if sender.value < 0  && isNextDay[sender.tag] {
                    isNextDay[sender.tag] = false
                    setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: 1425)
                    notificationForSetupNotificationsTime[sender.tag] = 1425
                    sender.setValue(Float(1425), animated: false)
                    
                    return
                    
                    
                } else if sender.value > 1425 && !isNextDay[sender.tag] {
                    
                    isNextDay[sender.tag] = true
                    setTimeInTimeLabel(timeLabel: timeLabel, amPmLabel: amPmLabel, nextDayLabel: nextDayLabel, isNextDay: isNextDay[sender.tag], time: 0)
                    notificationForSetupNotificationsTime[sender.tag] = 0
                    sender.setValue(Float(0), animated: false)
                    
                    
                    return
                }
                
            default:
                break
            }
        }
        
        
        
    }
    
}
