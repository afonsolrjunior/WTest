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

            expenseEntity.postalCodeNumber = $0.postalCodeNumber
            expenseEntity.postalCodeExtension = $0.postalCodeExtension
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
        request.fetchLimit = 50

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

    public func removeAddresses() {
        let context = self.managedObjectContext
        do {
            let addresses = try self.fetchAddresses(using: nil)
            addresses.forEach({ context.delete($0) })
            try context.save()
        } catch {

        }

    }

}
