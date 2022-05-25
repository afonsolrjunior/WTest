//
//  StorageService.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import CoreData

public enum StorageServiceError: String, Error {
    case saving
    case fetching
}

public protocol StorageServiceProtocol {
    func save(addresses: [Address]) throws
    func fetchAddresses(using predicate: NSPredicate?) throws -> [AddressEntity]
}

public class StorageService: StorageServiceProtocol {

    private let managedObjectContext: NSManagedObjectContext

    public init(managedObjectContext: NSManagedObjectContext = PersistanceController.shared.container.viewContext) {
        self.managedObjectContext = managedObjectContext
    }

    public func save(addresses: [Address]) throws {
        let context = self.managedObjectContext

        addresses.forEach({

            let expenseEntity = AddressEntity(context: context)

            expenseEntity.postalCodeNumber = Int64($0.postalCodeNumber)
            expenseEntity.postalCodeExtension = Int64($0.postalCodeExtension)
            expenseEntity.designation = $0.designation

        })

        do {
            try context.save()
        } catch {
            throw StorageServiceError.saving
        }
    }

    public func fetchAddresses(using predicate: NSPredicate?) throws -> [AddressEntity] {
        let context = self.managedObjectContext
        let request = AddressEntity.fetchRequest()

        if let predicate = predicate {
            request.predicate = predicate
        }

        do {
            let results = try context.fetch(request)
            return results
        } catch {
            throw StorageServiceError.fetching
        }
    }

}
