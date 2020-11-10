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
            return "Common"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
        
    }
}


enum NotificationSettingsTableViewCellTypeSundayFirst: Int, CaseIterable {
    case generalSettings = 0, sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var sectionTitle: String {
        switch self {
        case .generalSettings:
            return "Common"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
}
