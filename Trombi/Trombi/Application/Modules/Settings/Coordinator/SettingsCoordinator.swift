//
//  SettingsCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import RxSwift

public final class SettingsCoorinator: RxBaseCoordinator<String?> {
    let settingsFactory = SettingsFactory()
    let applicationData: ApplicationData
    
    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
        super.init(router: CoordinatorFactory.router(nil))
    }
    
    // swiftlint:disable:next function_body_length
    public override func start(with option: DeepLinkBase? = nil) -> Single<String?> {
        let usefulLinksViewModel = SettingsViewViewModel()
        let settingsController = settingsFactory.makeSettingsRootPresentable(with: usefulLinksViewModel)
        
        router.toPresent()?.tabBarItem = constructTabItem()
        router.setRootModule(settingsController)
        
        return usefulLinksViewModel.modelResult
    }
    
    private func constructTabItem() -> UITabBarItem {
        let settingsImage = UIImage(named: "icSettings")
        let settingsImageTranparent = UIImage(named: "icSettings")?.image(alpha: 0.9)
        
        let item = UITabBarItem(title: nil, image: settingsImageTranparent, tag: 0)
        item.selectedImage = settingsImage
        item.badgeColor = UIColor.mainBlackColor
        return item
    }
}
