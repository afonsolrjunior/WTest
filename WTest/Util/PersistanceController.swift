//
//  PersistanceController.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import CoreData

public struct PersistanceController {
    public static let shared = PersistanceController()

    public let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "WTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
