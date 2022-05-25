//
//  CoordinatorFactory.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation

public protocol CoordinatorFactoryProtocol {
    func makeAddressesListCoordinator() -> AddressesListCoordinatorProtocol
}

public class CoordinatorFactory: CoordinatorFactoryProtocol {

    public func makeAddressesListCoordinator() -> AddressesListCoordinatorProtocol {
        let viewContext = PersistanceController.shared.container.viewContext
        let storageService = StorageService(managedObjectContext: viewContext)
        let adapter = AddressAdapter()
        let addressService = AddressService(adapter: adapter, storageService: storageService)
        let viewModel = AddresssesListViewModel(addressesService: addressService)
        return AddressesListCoordinator(viewModel: viewModel)
    }

}


