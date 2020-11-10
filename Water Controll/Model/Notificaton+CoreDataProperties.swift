//
//  Notificaton+CoreDataProperties.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 28.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//
//

import Foundation
import CoreData


extension Notificaton {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notificaton> {
        return NSFetchRequest<Notificaton>(entityName: "Notificaton")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var isCommon: Bool
    @NSManaged public var name: String?
    @NSManaged public var start: Int16
    @NSManaged public var stop: Int16
    @NSManaged public var times: Int16
    @NSManaged public var user: User?
    @NSManaged public var notificationsTime: NSOrderedSet?

}

// MARK: Generated accessors for notificationsTime
extension Notificaton {

    @objc(insertObject:inNotificationsTimeAtIndex:)
    @NSManaged public func insertIntoNotificationsTime(_ value: NotificationsTime, at idx: Int)

    @objc(removeObjectFromNotificationsTimeAtIndex:)
    @NSManaged public func removeFromNotificationsTime(at idx: Int)

    @objc(insertNotificationsTime:atIndexes:)
    @NSManaged public func insertIntoNotificationsTime(_ values: [NotificationsTime], at indexes: NSIndexSet)

    @objc(removeNotificationsTimeAtIndexes:)
    @NSManaged public func removeFromNotificationsTime(at indexes: NSIndexSet)

    @objc(replaceObjectInNotificationsTimeAtIndex:withObject:)
    @NSManaged public func replaceNotificationsTime(at idx: Int, with value: NotificationsTime)

    @objc(replaceNotificationsTimeAtIndexes:withNotificationsTime:)
    @NSManaged public func replaceNotificationsTime(at indexes: NSIndexSet, with values: [NotificationsTime])

    @objc(addNotificationsTimeObject:)
    @NSManaged public func addToNotificationsTime(_ value: NotificationsTime)

    @objc(removeNotificationsTimeObject:)
    @NSManaged public func removeFromNotificationsTime(_ value: NotificationsTime)

    @objc(addNotificationsTime:)
    @NSManaged public func addToNotificationsTime(_ values: NSOrderedSet)

    @objc(removeNotificationsTime:)
    @NSManaged public func removeFromNotificationsTime(_ values: NSOrderedSet)

}
