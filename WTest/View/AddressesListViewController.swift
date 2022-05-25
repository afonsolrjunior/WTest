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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.isHidden = false
        return loadingIndicator
    }()

    private let viewModel: AddresssesListViewModelProtocol
    private let disposeBag = DisposeBag()

    private var keyboardHeight: CGFloat = 0

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
        setupBinds()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.frame.origin.y -= keyboardSize.height
            keyboardHeight = keyboardSize.height
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        tableView.frame.origin.y += keyboardHeight
    }


}

extension AddressesListViewController {

    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()

        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

    }

    private func setupBinds() {

        self.viewModel.output.addresses.observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self))) {[weak self] _, address, cell in
                guard let self = self else { return }
                var configuration = UIListContentConfiguration.cell()
                configuration.attributedText = self.viewModel.getFormmatedString(for: address)
                cell.contentConfiguration = configuration
            }.disposed(by: disposeBag)

        self.searchBar.rx.text.orEmpty.bind(to: self.viewModel.input.text).disposed(by: disposeBag)
        self.searchBar.rx.searchButtonClicked.asDriver().drive {[weak self] _ in
            self?.searchBar.endEditing(true)
        }.disposed(by: disposeBag)


        self.viewModel.output.isLoading.asDriver(onErrorDriveWith: .just(false)).asObservable().subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            //self.loadingIndicator.isHidden = !isLoading
            if isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }

}

