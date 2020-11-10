//
//  AccessController+CoreDataProperties.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 09.08.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//
//

import Foundation
import CoreData


extension AccessController {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccessController> {
        return NSFetchRequest<AccessController>(entityName: "AccessController")
    }

    @NSManaged public var premiumAccount: Bool
    @NSManaged public var bottelsAvailable: Int16
    @NSManaged public var currentDate: Date?

}
