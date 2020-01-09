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

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    var viewModel: MainTabBarViewViewModel?

    private var splashViewController: SplashViewController?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabs()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if splashViewController == nil {
            performSegue(withIdentifier: "Splash", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let splashViewController = segue.destination as? SplashViewController {
            self.splashViewController = splashViewController
            self.splashViewController?.applicationData.asObservable().subscribe({ [weak self] event in
                switch event {
                case .completed, .error(_):
                    break
                case .next(let applicationData):
                    if let safeApplicationData = applicationData {
                        self?.viewModel?.homeViewViewModel.applicationData = safeApplicationData
                        self?.viewModel?.usefulLinksViewViewModel.applicationData = safeApplicationData
                        self?.splashViewController?.dismiss(animated: false, completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
        }
    }

    // MARK: - Tabs init
    private func initTabs() {
        viewControllers?.forEach({ tabViewController in
            if let navigationController = tabViewController as? UINavigationController {
                if let homeViewController = navigationController.viewControllers.first as? HomeViewController {
                    homeViewController.viewModel = viewModel?.homeViewViewModel
                } else if let usefulLinksViewController =
                    navigationController.viewControllers.first as? UsefulLinksViewController {
                    usefulLinksViewController.viewModel = viewModel?.usefulLinksViewViewModel
                }
            }
        })
    }
}
