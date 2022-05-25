//
//  AddressEntity+CoreDataProperties.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//
//

import Foundation
import CoreData


extension AddressEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressEntity> {
        return NSFetchRequest<AddressEntity>(entityName: "AddressEntity")
    }

    @NSManaged public var postalCodeNumber: String?
    @NSManaged public var postalCodeExtension: String?
    @NSManaged public var designation: String?

}

extension AddressEntity : Identifiable {

}
