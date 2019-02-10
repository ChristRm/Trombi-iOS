//
//  MainTabBarViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift

final class MainTabBarViewController: UITabBarController {

    // MARK: - Properties

    var viewModel: MainTabBarViewViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabs()
        viewModel?.loadAppData()
    }

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Tabs init
    private func initTabs() {

        viewControllers?.forEach({ tabViewController in
            if let navigationController = tabViewController as? UINavigationController {
                if let employeesViewController = navigationController.viewControllers.first as? EmployeesViewController {
                    employeesViewController.viewModel = viewModel?.employeesViewViewModel
                }
            }
        })

    }
}
