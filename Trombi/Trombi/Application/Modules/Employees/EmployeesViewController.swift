//
//  EmployeesViewController.swift
//  Trombi
//
//  Created by Christian Rusin  on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

final class EmployeesViewController: UIViewController {

    var viewModel: EmployeesViewViewModel? {
        didSet {
            if let viewModel = viewModel {
                bindViewModel(viewModel)
            }
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "People"
        setupTableView()
    }

    // MARK: - Private methods
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
    }

    private func bindViewModel(_ viewModel: EmployeesViewViewModel) {
        
    }
}

// MARK: - UITableViewDelegate
extension EmployeesViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension EmployeesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? EmployeeTableViewCell else {
                                                        fatalError("Unexpected Table View Cell")
        }

        return cell
    }
}
