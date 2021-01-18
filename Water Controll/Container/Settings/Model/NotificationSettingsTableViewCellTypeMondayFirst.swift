//
//  NotificationSettingsTableViewCellType.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 13.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

enum NotificationSettingsTableViewCellTypeMondayFirst: Int, CaseIterable {
    case generalSettings = 0, monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var sectionTitle: String {
        switch self {
        case .generalSettings:
            return AppTexts.commonAppTexts
        case .monday:
            return AppTexts.mondayAppTexts
        case .tuesday:
            return AppTexts.tuesdayAppTexts
        case .wednesday:
            return AppTexts.wednesdayAppTexts
        case .thursday:
            return AppTexts.thursdayAppTexts
        case .friday:
            return AppTexts.fridayAppTexts
        case .saturday:
            return AppTexts.saturdayAppTexts
        case .sunday:
            return AppTexts.sundayAppTexts
        }
    }
    var notificationName: String {
        switch self {
        case .generalSettings:
            return "general"
        case .monday:
            return "monday"
        case .tuesday:
            return "tuesday"
        case .wednesday:
            return "wednesday"
        case .thursday:
            return "thursday"
        case .friday:
            return "friday"
        case .saturday:
            return "saturday"
        case .sunday:
            return "sunday"
        }
    }
    
}


enum NotificationSettingsTableViewCellTypeSundayFirst: Int, CaseIterable {
    case generalSettings = 0, sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var sectionTitle: String {
        switch self {
        case .generalSettings:
            return AppTexts.commonAppTexts
        case .monday:
            return AppTexts.mondayAppTexts
        case .tuesday:
            return AppTexts.tuesdayAppTexts
        case .wednesday:
            return AppTexts.wednesdayAppTexts
        case .thursday:
            return AppTexts.thursdayAppTexts
        case .friday:
            return AppTexts.fridayAppTexts
        case .saturday:
            return AppTexts.saturdayAppTexts
        case .sunday:
            return AppTexts.sundayAppTexts
        }
    }
    
    var notificationName: String {
        switch self {
        case .generalSettings:
            return "general"
        case .monday:
            return "monday"
        case .tuesday:
            return "tuesday"
        case .wednesday:
            return "wednesday"
        case .thursday:
            return "thursday"
        case .friday:
            return "friday"
        case .saturday:
            return "saturday"
        case .sunday:
            return "sunday"
        }
    }
}
