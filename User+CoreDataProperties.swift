//
//  User+CoreDataProperties.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.10.2020.
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
    // volume was drank
    @NSManaged public var currentVolume: Float
    //volume in bottle
    @NSManaged public var currentVolumeInBottle: Float
    @NSManaged public var fullVolume: Float
    @NSManaged public var identifire: String?
    @NSManaged public var isAutoFillBottleType: Bool
    @NSManaged public var isEmptyBottle: Bool
    @NSManaged public var middlePourWaterVolume: Int16
    @NSManaged public var name: String?
    @NSManaged public var notificationIdentifire: String?
    @NSManaged public var volumeType: String?
    @NSManaged public var gotWaters: NSOrderedSet?
    @NSManaged public var notifications: NSOrderedSet?

}

// MARK: Generated accessors for gotWaters
extension User {

    @objc(insertObject:inGotWatersAtIndex:)
    @NSManaged public func insertIntoGotWaters(_ value: GotWater, at idx: Int)

    @objc(removeObjectFromGotWatersAtIndex:)
    @NSManaged public func removeFromGotWaters(at idx: Int)

    @objc(insertGotWaters:atIndexes:)
    @NSManaged public func insertIntoGotWaters(_ values: [GotWater], at indexes: NSIndexSet)

    @objc(removeGotWatersAtIndexes:)
    @NSManaged public func removeFromGotWaters(at indexes: NSIndexSet)

    @objc(replaceObjectInGotWatersAtIndex:withObject:)
    @NSManaged public func replaceGotWaters(at idx: Int, with value: GotWater)

    @objc(replaceGotWatersAtIndexes:withGotWaters:)
    @NSManaged public func replaceGotWaters(at indexes: NSIndexSet, with values: [GotWater])

    @objc(addGotWatersObject:)
    @NSManaged public func addToGotWaters(_ value: GotWater)

    @objc(removeGotWatersObject:)
    @NSManaged public func removeFromGotWaters(_ value: GotWater)

    @objc(addGotWaters:)
    @NSManaged public func addToGotWaters(_ values: NSOrderedSet)

    @objc(removeGotWaters:)
    @NSManaged public func removeFromGotWaters(_ values: NSOrderedSet)

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
