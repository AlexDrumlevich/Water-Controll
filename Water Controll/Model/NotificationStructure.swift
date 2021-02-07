//
//  NotificationStructure.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 05.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation



struct NotificationsStructure {
    var isActive: Bool!
    var isCommon: Bool!
    // language depended
    var name: String!
    
    var start: Int16!
    var stop: Int16!
    var times: Int16!
    var notificationsTimeADay: [Int16]!
}


enum NotificationCategories: String {
    case timeToDrink, reminder
}


enum NotificationActionTypes: String {
    
    case later = "Later", dissmis = "Dissmis", fiveMinutesLater = "5 minutes later", tenMinutesLater = "10 minutes later", fifteenMinutesLater = "15 minutes later"
}
