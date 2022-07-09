//
//  MainTabBarViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift

final class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    override var viewControllers: [UIViewController]? {
        didSet {
            initTabs()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.black
        initTabs()
    }

    // MARK: - Tabs init
    private func initTabs() {
        self.selectedIndex = 0
    }
}
