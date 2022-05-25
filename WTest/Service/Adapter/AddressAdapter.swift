//
//  AddressAdapter.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import CoreData

public protocol AddressAdapterProtocol {
    func adapt(entity: AddressEntity) -> Address
}

public class AddressAdapter: AddressAdapterProtocol {

    public init() {}

    public func adapt(entity: AddressEntity) -> Address {
        let postalCodeNumber = Int(entity.postalCodeNumber)
        let postalCodeExtension = Int(entity.postalCodeExtension)
        let designation = entity.designation ?? "Unknown"
        return Address(postalCodeNumber: postalCodeNumber,
                       postalCodeExtension: postalCodeExtension,
                       designation: designation)
    }
}
