//
//  MainTabBarViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

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
    func bindViewModel(_ viewModel: MainTabBarViewViewModel) { }
}
