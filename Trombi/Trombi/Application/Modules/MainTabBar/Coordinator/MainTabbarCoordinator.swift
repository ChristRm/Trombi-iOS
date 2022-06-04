//
//  MainTabbarCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift

final class MainTabbarCoordinator: RxBaseCoordinator<Any> {
    let tabbarController: UITabBarController = UITabBarController()
    let coordinatorFactory: CoordinatorFactory
    let applicationData: ApplicationData
    
    init(coordinatorFactory: CoordinatorFactory, applicationData: ApplicationData) {
        self.coordinatorFactory = coordinatorFactory
        self.applicationData = applicationData
        super.init(router: CoordinatorFactory.router(nil))
    }
    
    // swiftlint:disable:next function_body_length
    override func start(with option: DeepLinkBase? = nil) -> Single<Any> {
        let homeCoordinator = prepareHomeModuleCoordinator(with: option)
        
        let usefulLinksCoordinator = prepareUsefulLinksModuleCoordinator(with: option)
        let settingsCoordinator = prepareSettingsModuleCoordinator(with: option)
        
        let tabViewControllers: [UIViewController] =
            [homeCoordinator.router.toPresent() as? UINavigationController ?? UIViewController(),
             usefulLinksCoordinator.router.toPresent() as? UINavigationController ?? UIViewController(),
             settingsCoordinator.router.toPresent() as? UINavigationController ?? UIViewController()]
        
        tabbarController.viewControllers = tabViewControllers
        
        addChild(coordinator: homeCoordinator)
        homeCoordinator.start()
            .subscribe()
            .disposed(by: bag)
        
        addChild(coordinator: usefulLinksCoordinator)
        usefulLinksCoordinator.start()
            .subscribe()
            .disposed(by: bag)
        
        return coordinate(to: settingsCoordinator).map({ $0 as Any })
    }
    
    func prepareHomeModuleCoordinator(with option: DeepLinkBase? = nil) -> RxBaseCoordinator<Any> {
        return HomeCoordinator(applicationData: applicationData)
    }

    func prepareUsefulLinksModuleCoordinator(with option: DeepLinkBase? = nil) -> RxBaseCoordinator<Any> {
        return UsefulLinksCoorinator(applicationData: applicationData)
    }

    func prepareSettingsModuleCoordinator(with option: DeepLinkBase? = nil) -> RxBaseCoordinator<String?> {
        return SettingsCoorinator(applicationData: applicationData)
    }
    
    func prepareXModuleCoordinator(with option: DeepLinkBase? = nil) -> RxBaseCoordinator<Void> {
        return RxBaseCoordinator<Void>(router: CoordinatorFactory.router(nil))
    }
}
