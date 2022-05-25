//
//  AddressesListViewModel.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import RxSwift
import RxCocoa

public struct AddressesListViewModelInput {
    let text: BehaviorRelay<String> = .init(value: "")
}

public struct AddressesListViewModelOutput {
    let addresses: BehaviorRelay<[Address]> = .init(value: [])
}

public protocol AddresssesListViewModelProtocol {
    var input: AddressesListViewModelInput { get }
    var output: AddressesListViewModelOutput { get }
}

public class AddresssesListViewModel: AddresssesListViewModelProtocol {
    public var input: AddressesListViewModelInput = .init()
    public var output: AddressesListViewModelOutput = .init()

    private let addressesService: AddressServiceProtocol
    private let disposeBag = DisposeBag()

    public init(addressesService: AddressServiceProtocol = AddressService()) {
        self.addressesService = addressesService
    }

    private func bindInput() {
        input.text.throttle(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { searchTerm -> Observable<[Address]> in
                if searchTerm.isEmpty {
                    return self.addressesService.fetchAddresses(using: nil)
                } else {
                    return self.addressesService.fetchAddresses(using: nil)
                }
            }.observe(on: MainScheduler.instance)
            .bind(to: self.output.addresses).disposed(by: disposeBag)
    }

}
