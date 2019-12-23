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

enum SearchTableElementModel {
    case employee(EmployeeSearchCellModel)
    case lastSearch(String)
}

class SearchViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    var viewModel: SearchViewViewModel?

    // MARK: - Properties
    private let searchController = TrombiSearchBarController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsView: UIView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBarController()

        if let viewModel = viewModel {
            bindViewModel(viewModel)
        } else {
            print("SearchViewViewModel is not set up")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()

        navigationController?.navigationBar.clipsToBounds = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.clipsToBounds = false
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: SearchViewViewModel) {
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

        _ = searchController.searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .bind(to: viewModel.enteredSearch)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked.subscribe { [weak self] _ in
            self?.searchController.searchBar.resignFirstResponder()
            if let text = self?.searchController.searchBar.text {
                self?.viewModel?.addLastSearch(text)
            }
        }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .map({ indexPath -> Int in return indexPath.row })
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)

        viewModel.forcedSearchText.drive(onNext: { [weak self] forceSearchText in
            guard let forceSearchText = forceSearchText else { return }
            self?.searchController.searchBar.text = forceSearchText
            self?.viewModel?.enteredSearch.accept(forceSearchText)
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

    fileprivate func setupSearchBarController() {
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"

        searchController.trombiDelegate = self

        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}

extension SearchViewController: TrombiSearchBarControllerDelegate {
    func dismissTapped() {
        navigationController?.dismiss(animated: false, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {
    // TODO: Handle events of UISearchControllerDelegate
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}
