//
//  AccessController+CoreDataProperties.swift
//  
//
//  Created by ALEXEY DRUMLEVICH on 03.01.2021.
//
//

import Foundation
import CoreData


extension AccessController {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccessController> {
        return NSFetchRequest<AccessController>(entityName: "AccessController")
    }

    @NSManaged public var bottelsAvailable: Int16
    @NSManaged public var currentDate: Date?
    @NSManaged public var isGotConsent: Bool
    @NSManaged public var premiumAccount: Bool
    @NSManaged public var lastWatchingRewardAdsTime: Date?
    @NSManaged public var needTimesPourWaterToCallRateTheApp: Int16
    @NSManaged public var boundelAppRated: String?

}
