//
//  AddressesListCoordinator.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import UIKit

public protocol AddressesListCoordinatorProtocol {
    func start(window: UIWindow)
}

public class AddressesListCoordinator: AddressesListCoordinatorProtocol {

    private let viewModel: AddresssesListViewModelProtocol

    public init(viewModel: AddresssesListViewModelProtocol) {
        self.viewModel = viewModel
    }

    public func start(window: UIWindow) {
        let viewController = AddressesListViewController(viewModel: self.viewModel)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

}
