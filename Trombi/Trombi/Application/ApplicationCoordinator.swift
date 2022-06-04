//
//  ApplicationCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift

class ApplicationCoordinator: RxBaseCoordinator<Void> {
    var window: UIWindow
    private let coordinatorFactory: CoordinatorFactory

    init(window: UIWindow, coordinatorFactory: CoordinatorFactory) {
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        
        window.makeKeyAndVisible()
        
        super.init(router: CoordinatorFactory.router(nil))
    }

    override func start(with option: DeepLinkBase? = nil) -> Single<Void> {
        Single<Void>.create { [weak self] _ in
            self?.runApplicationFlow(option: option)
            return Disposables.create()
        }
    }

    // MARK: - Deep link
    override func handle(deepLink: DeepLinkBase) { }
    
    func runApplicationFlow(option: DeepLinkBase?) {
        showSplashScreen()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: { [weak self] applicationData in
                self?.runMainFlow(applicationData: applicationData)
            })
            .disposed(by: bag)
    }
    
    func showSplashScreen() -> Single<ApplicationData> {
        let controller = SplashViewController()
        window.rootViewController = controller
        return controller.modelResult
    }
    
    func runMainFlow(applicationData: ApplicationData) {
        let mainTabbarCoordinator = MainTabbarCoordinator(coordinatorFactory: coordinatorFactory,
                                                          applicationData: applicationData)
        coordinate(to: mainTabbarCoordinator)
            .subscribe(onSuccess: { [weak self] _ in
                self?.runApplicationFlow(option: nil)
            })
            .disposed(by: bag)
        
        window.rootViewController = mainTabbarCoordinator.tabbarController.toPresent()
        window.makeKeyAndVisible()
    }
}
