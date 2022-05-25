//
//  AddressService.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import CoreData
import RxSwift
import CodableCSV

public enum AddressServiceError: Error {
    case decoding
    case invalidUrl
    case custom(error: Error?)
    case invalidReponse
    case unhandled
    case invalidData
}

public protocol AddressServiceProtocol {
    func fetchAddresses(using predicate: NSPredicate?) -> Observable<[Address]>
}

public class AddressService: AddressServiceProtocol {

    let adapter: AddressAdapterProtocol
    let storageService: StorageServiceProtocol

    public init(adapter: AddressAdapterProtocol = AddressAdapter(),
                storageService: StorageServiceProtocol = StorageService()) {
        self.adapter = adapter
        self.storageService = storageService
    }

    public func fetchAddresses(using predicate: NSPredicate? = nil) -> Observable<[Address]> {

        return Observable.create {[weak self] observer -> Disposable in

            guard let self = self else {
                observer.onError(AddressServiceError.unhandled)
                return Disposables.create()
            }

            let storedAddresses = self.getStoredAddresses(using: predicate)

            if !storedAddresses.isEmpty {

                observer.onNext(storedAddresses.map({ self.adapter.adapt(entity: $0) }))
                return Disposables.create()

            } else if let url = URL(string: ServiceConfiguration.baseUrlString) {

                let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

                    guard error == nil else {
                        observer.onError(AddressServiceError.custom(error: error))
                        return
                    }

                    guard let data = data else {
                        observer.onError(AddressServiceError.invalidData)
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        observer.onError(AddressServiceError.invalidReponse)
                        return
                    }

                    do {
                        let decoder = CSVDecoder { $0.headerStrategy = .firstLine }
                        let addresses = try decoder.decode([Address].self, from: data)

                        try self.saveAddressesToStorage(addresses)
                        observer.onNext(addresses)
                        observer.onCompleted()
                    } catch {
                        observer.onError(AddressServiceError.custom(error: error))
                    }

                }

                dataTask.resume()

                return Disposables.create {
                    dataTask.cancel()
                }

            } else {
                observer.onError(AddressServiceError.invalidUrl)

                return Disposables.create()
            }


        }
    }

    private func saveAddressesToStorage(_ addresses: [Address]) throws {
        try storageService.save(addresses: addresses)
    }

    private func getStoredAddresses(using predicate: NSPredicate? = nil) -> [AddressEntity] {

        do {
            let addresses = try storageService.fetchAddresses(using: predicate)
            return addresses
        } catch {
            return []
        }


    }

}
