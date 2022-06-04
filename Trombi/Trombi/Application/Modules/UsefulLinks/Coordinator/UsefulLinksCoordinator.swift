//
//  UsefulLinksCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//


import RxSwift

public final class UsefulLinksCoorinator: RxBaseCoordinator<Any> {
    let usefulLinksFactory = UsefulLinksFactory()
    let applicationData: ApplicationData
    
    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
        super.init(router: CoordinatorFactory.router(nil))
    }
    
    // swiftlint:disable:next function_body_length
    public override func start(with option: DeepLinkBase? = nil) -> Single<Any> {
        let usefulLinksViewModel = UsefulLinksViewViewModel(applicationData: applicationData)
        let usefulLinksController = usefulLinksFactory.makeUsefulLinksRootPresentable(with: usefulLinksViewModel)
        
        router.toPresent()?.tabBarItem = constructTabItem()
        router.setRootModule(usefulLinksController)
        
        return usefulLinksViewModel.modelResult
    }
    
    private func constructTabItem() -> UITabBarItem {
        let item = UITabBarItem(title: nil, image: UIImage(named: "icLinks"), tag: 0)
        item.selectedImage = UIImage(named: "icLinksActive")
        item.badgeColor = UIColor.mainBlackColor
        return item
    }
}
