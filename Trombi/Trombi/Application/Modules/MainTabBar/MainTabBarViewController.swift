//
//  MainTabBarViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    // MARK: - Properties

    var viewModel: MainTabBarViewViewModel? {
        didSet {
            if let viewModel = viewModel {
                bindViewModel(viewModel)
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.loadAppData()
    }

    // MARK: - ViewModel setup
    private func bindViewModel(_ viewModel: MainTabBarViewViewModel) { }

    // MARK: - Tabs init
    private func initTabs() {
        if let employeesViewController = viewControllers?.first as? EmployeesViewController {
//            employeesViewController.viewMod
        }
    }
}
