//
//  GotWater+CoreDataProperties.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.10.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//
//

import Foundation
import CoreData


extension GotWater {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GotWater> {
        return NSFetchRequest<GotWater>(entityName: "GotWater")
    }

    @NSManaged public var data: Date?
    @NSManaged public var volumeGet: Float
    @NSManaged public var volumeTarget: Float
    @NSManaged public var isOzType: Bool
    @NSManaged public var user: User?

}
