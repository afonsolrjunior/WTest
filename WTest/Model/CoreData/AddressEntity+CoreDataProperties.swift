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

    @NSManaged public var postalCodeNumber: Int64
    @NSManaged public var postalCodeExtension: Int64
    @NSManaged public var designation: String?


}

extension AddressEntity : Identifiable {

}
