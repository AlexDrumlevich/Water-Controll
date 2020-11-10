//
//  NotificationsTime+CoreDataProperties.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 28.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//
//

import Foundation
import CoreData


extension NotificationsTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationsTime> {
        return NSFetchRequest<NotificationsTime>(entityName: "NotificationsTime")
    }

    @NSManaged public var notificationTime: Int16
    @NSManaged public var notification: Notificaton?

}
