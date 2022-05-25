//
//  AddressService.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import CoreData
import RxSwift

public protocol AddressServiceProtocol {
    func fetchAllAddresses() -> Observable<[Address]>
    func fetchAddresses(matching postalCodeNumber: Int?, postalCodeExtension: Int?, designation: String?) -> Observable<[Address]>
}


