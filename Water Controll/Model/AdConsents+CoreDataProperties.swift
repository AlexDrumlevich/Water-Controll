//
//  AdConsents+CoreDataProperties.swift
//  
//
//  Created by ALEXEY DRUMLEVICH on 18.11.2020.
//
//

import Foundation
import CoreData


extension AdConsents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdConsents> {
        return NSFetchRequest<AdConsents>(entityName: "AdConsents")
    }

    @NSManaged public var date: Date?
    @NSManaged public var textOfConsent: String?

}
