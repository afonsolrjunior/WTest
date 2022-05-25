//
//  AddressesListViewController.swift
//  WTest
//
//  Created by afonso.junior on 24/05/22.
//

import UIKit
import RxSwift

class AddressesListViewController: UIViewController {

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()

    private let viewModel: AddresssesListViewModelProtocol
    private let disposeBag = DisposeBag()

    public init(viewModel: AddresssesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }


}

extension AddressesListViewController {

    private func setupViews() {
        self.viewModel.output.addresses
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self))) { _, address, cell in
                var configuration = UIListContentConfiguration.cell()
                configuration.text = "\(address.postalCodeExtension)-\(address.postalCodeNumber) \(address.designation)"
                cell.contentConfiguration = configuration
            }.disposed(by: disposeBag)

        self.searchBar.rx.text.orEmpty.bind(to: self.viewModel.input.text).disposed(by: disposeBag)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)

        ])
    }

}

