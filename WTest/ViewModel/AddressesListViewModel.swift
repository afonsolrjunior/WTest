//
//  AddressesListViewModel.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public struct AddressesListViewModelInput {
    let text: BehaviorRelay<String> = .init(value: "")
}

public struct AddressesListViewModelOutput {
    let addresses: BehaviorRelay<[Address]> = .init(value: [])
    let isLoading: BehaviorSubject<Bool> = .init(value: true)
}

public protocol AddresssesListViewModelProtocol {
    var input: AddressesListViewModelInput { get }
    var output: AddressesListViewModelOutput { get }
    func getFormmatedString(for address: Address) -> NSMutableAttributedString
}

public class AddresssesListViewModel: AddresssesListViewModelProtocol {
    public var input: AddressesListViewModelInput = .init()
    public var output: AddressesListViewModelOutput = .init()

    private let addressesService: AddressServiceProtocol
    private let disposeBag = DisposeBag()

    public init(addressesService: AddressServiceProtocol = AddressService()) {
        self.addressesService = addressesService
        bindInput()
    }

    private func bindInput() {
        input.text.skip(1).throttle(.milliseconds(400), scheduler: ConcurrentMainScheduler.instance)
            .distinctUntilChanged()
            .do(onNext: { _ in
                self.output.isLoading.onNext(true)
            }, onError: { _ in
                self.output.isLoading.onNext(true)
            })
            .flatMapLatest { searchTerm -> Observable<[Address]> in
                self.addressesService.fetchAddresses(using: self.createPredicate(for: searchTerm))
            }
            .bind(to: self.output.addresses).disposed(by: disposeBag)

        output.addresses.skip(1).subscribe(onNext: { _ in
            self.output.isLoading.onNext(false)
        }, onError: { _ in
            self.output.isLoading.onNext(false)
        }).disposed(by: disposeBag)
    }

    public func getFormmatedString(for address: Address) -> NSMutableAttributedString {
        let formattedString = "\(address.postalCodeNumber)-\(address.postalCodeExtension) \(address.designation)"
        let attributedString = NSMutableAttributedString(string: formattedString)
        let range = NSRange(location: 0, length: formattedString.count)
        let boldRange = NSRange(location: 0, length: address.postalCodeNumber.count)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: range)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: boldRange)
        return attributedString
    }

    private func createPredicate(for searchTerm: String) -> NSPredicate? {
        guard !searchTerm.isEmpty else { return nil }
        let components = searchTerm.split(maxSplits: 5, omittingEmptySubsequences: true) { character in
            !character.isLetter && !character.isWholeNumber
        }

        let predicates = components.map({ component -> NSPredicate in
            let string = String(component)
            if string.isNumber {
                if string.count > 3 {
                    return NSPredicate(format: "postalCodeNumber contains[cd] %@", string)
                } else {
                    return NSPredicate(format: "postalCodeExtension contains[cd] %@", string)
                }
            } else {
                return NSPredicate(format: "designation contains[cd] %@", string)
            }

        })

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

}
