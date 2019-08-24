//
//  SearchViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 8/24/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    private let searchController =
        UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        initSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
//        searchController.searchBar.becomeFirstResponder()
//        searchBar.becomeFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController {
    fileprivate func initSearchBar() {
        // from medix-news
//        searchBar.tintColor = UIColor.gray
//        searchBar.layer.borderWidth = 1
//        searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
//        searchBar.delegate = self

        
//        leadingSearchBarConstraint.constant = 0
//        trailingSearchBarConstraint.constant = 0
//        UIView.animate(withDuration: 0.01) {
//            self.searchBar.layoutIfNeeded()
//        }


        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search Candies"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
}

extension SearchViewController: UISearchBarDelegate {

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //TODO: update
    }


}

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}
