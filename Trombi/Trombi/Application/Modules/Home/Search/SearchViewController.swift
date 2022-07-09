//
//  SearchViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 8/24/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAtomic

public enum SearchTableElementModel {
    case employee(EmployeeSearchCellModel)
    case lastSearch(String)
}

final class SearchViewController<ViewModel: SearchViewViewModelInterface>: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: SearchViewController.identifier, bundle: SearchViewController.bundle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties
    private lazy var trombiSearchBar = TrombiSearchBar(frame: .zero)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsView: UIView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        trombiSearchBar.sizeToFit()
        trombiSearchBar.placeholder = "Search"
        trombiSearchBar.trombiDelegate = self
        navigationItem.titleView = trombiSearchBar

        bindViewModel(viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trombiSearchBar.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.clipsToBounds = false
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: ViewModel) {
        viewModel.searchTable
            .asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, searchDataModel) -> UITableViewCell in
            switch searchDataModel {
            case .employee(let employeeSearchCellModel):
                let employeeCell: EmployeeSearchTableViewCell =
                    tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0))

                employeeCell.setModel(employeeSearchCellModel)
                return employeeCell
            case .lastSearch(let lastSearch):
                let lastSearchCell: LastSearchTableViewCell =
                    tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0))

                lastSearchCell.setText(lastSearch)
                return lastSearchCell
            }
        }.disposed(by: disposeBag)

        viewModel.noResultsIsHidden.drive(noResultsView.rx.isHidden).disposed(by: disposeBag)

        trombiSearchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .bind(to: viewModel.enteredSearch)
            .disposed(by: disposeBag)

        trombiSearchBar.rx.searchButtonClicked.subscribe { [weak self] _ in
            self?.trombiSearchBar.resignFirstResponder()
            if let text = self?.trombiSearchBar.text {
                self?.viewModel.lastSearch.onNext(text)
            }
        }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .map({ indexPath -> Int in return indexPath.row })
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)

        viewModel.forcedSearchText.drive(onNext: { [weak self] forceSearchText in
            guard let forceSearchText = forceSearchText else { return }
            self?.trombiSearchBar.text = forceSearchText
            self?.viewModel.enteredSearch.accept(forceSearchText)
        }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    fileprivate func setupTableView() {
        tableView.registerReusableCell(type: EmployeeSearchTableViewCell.self)
        tableView.registerReusableCell(type: LastSearchTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension SearchViewController: TrombiSearchBarDelegate {
    func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}
