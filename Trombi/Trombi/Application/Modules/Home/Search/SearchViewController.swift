//
//  SearchViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 8/24/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    // MARK: - Properties
    private let searchController = TrombiSearchBarController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.registerReusableCell(type: EmployeeTableViewCell.self)
        setupSearchBarController()
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfoCell: EmployeeTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        userInfoCell.avatarImageView = nil
        userInfoCell.nameLabel?.text = "Name"
        userInfoCell.positionLabel?.text = "Position"
        userInfoCell.teamLabel?.text = "Team"

        return userInfoCell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension SearchViewController {
    fileprivate func setupSearchBarController() {

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search Candies"
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
    // TODO: Handle events of UISearchBarDelegate
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    // TODO: Handle events of UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {

    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {
    // TODO: Handle events of UISearchControllerDelegate
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}
