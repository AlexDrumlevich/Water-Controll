//
//  User+CoreDataProperties.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 15.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var currentDate: Date?
    @NSManaged public var currentUser: Bool
    @NSManaged public var currentVolume: Float
    @NSManaged public var fullVolume: Float
    @NSManaged public var identifire: String?
    @NSManaged public var name: String?
    @NSManaged public var volumeType: String?
    @NSManaged public var gotWater: NSSet?
    @NSManaged public var notifications: NSOrderedSet?

}

// MARK: Generated accessors for gotWater
extension User {

    @objc(addGotWaterObject:)
    @NSManaged public func addToGotWater(_ value: GotWater)

    @objc(removeGotWaterObject:)
    @NSManaged public func removeFromGotWater(_ value: GotWater)

    @objc(addGotWater:)
    @NSManaged public func addToGotWater(_ values: NSSet)

    @objc(removeGotWater:)
    @NSManaged public func removeFromGotWater(_ values: NSSet)

}

// MARK: Generated accessors for notifications
extension User {

    @objc(insertObject:inNotificationsAtIndex:)
    @NSManaged public func insertIntoNotifications(_ value: Notificaton, at idx: Int)

    @objc(removeObjectFromNotificationsAtIndex:)
    @NSManaged public func removeFromNotifications(at idx: Int)

    @objc(insertNotifications:atIndexes:)
    @NSManaged public func insertIntoNotifications(_ values: [Notificaton], at indexes: NSIndexSet)

    @objc(removeNotificationsAtIndexes:)
    @NSManaged public func removeFromNotifications(at indexes: NSIndexSet)

    @objc(replaceObjectInNotificationsAtIndex:withObject:)
    @NSManaged public func replaceNotifications(at idx: Int, with value: Notificaton)

    @objc(replaceNotificationsAtIndexes:withNotifications:)
    @NSManaged public func replaceNotifications(at indexes: NSIndexSet, with values: [Notificaton])

    @objc(addNotificationsObject:)
    @NSManaged public func addToNotifications(_ value: Notificaton)

    @objc(removeNotificationsObject:)
    @NSManaged public func removeFromNotifications(_ value: Notificaton)

    @objc(addNotifications:)
    @NSManaged public func addToNotifications(_ values: NSOrderedSet)

    @objc(removeNotifications:)
    @NSManaged public func removeFromNotifications(_ values: NSOrderedSet)

}
