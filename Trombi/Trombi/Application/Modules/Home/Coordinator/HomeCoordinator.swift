//
//  HomeCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import RxSwift

public final class HomeCoordinator: RxBaseCoordinator<Any>, UserProfilePresenting {
    let homeFactory = HomeFactory()
    let applicationData: ApplicationData
    
    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
        super.init(router: CoordinatorFactory.router(nil))
    }
    
    // swiftlint:disable:next function_body_length
    public override func start(with option: DeepLinkBase? = nil) -> Single<Any> {
        let homeViewModel = HomeViewViewModel(applicationData: applicationData)
        let homeController = homeFactory.makeHomeRootPresentable(with: homeViewModel)
        
        router.toPresent()?.tabBarItem = constructTabItem()
        router.setRootModule(homeController)
        
        homeViewModel
            .openSearch
            .subscribe(onNext: { [weak self] in
            self?.pushSearchScreen()
        })
        .disposed(by: bag)
        
        homeViewModel
            .openEmployee
            .subscribe(onNext: { [weak self] employeeAndTeam in
                self?.openUserProfile(employeeAndTeam)
        })
        .disposed(by: bag)
        
        return homeViewModel.modelResult
    }
    
    func pushSearchScreen() {
        let searchCoordinator = SearchCoordinator(applicationData: applicationData)

        router.present(searchCoordinator.router.toPresent())
        
        coordinate(to: searchCoordinator)
            .subscribe()
            .disposed(by: bag)
    }
}

extension HomeCoordinator {
    
    private func constructTabItem() -> UITabBarItem {
        let item = UITabBarItem(title: nil, image: UIImage(named: "icHome"), tag: 0)
        item.selectedImage = UIImage(named: "icHomeActive")
        item.badgeColor = UIColor.mainBlackColor
        return item
    }
}
