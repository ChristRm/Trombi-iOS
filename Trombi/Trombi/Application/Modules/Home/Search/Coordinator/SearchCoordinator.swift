//
//  HomeCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import RxSwift

public final class SearchCoordinator: RxBaseCoordinator<Any>, UserProfilePresenting {
    let homeFactory = HomeFactory()
    let applicationData: ApplicationData
    
    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
        super.init(router: CoordinatorFactory.router(nil))
    }
    
    // swiftlint:disable:next function_body_length
    public override func start(with option: DeepLinkBase? = nil) -> Single<Any> {
        let searchViewModel = SearchViewViewModel(applicationData: applicationData)
        let searchController = homeFactory.makeSearchScreenPresentable(with: searchViewModel)
        
        searchViewModel
            .openEmployee
            .asObservable()
            .subscribe(onNext: { [weak self] employeeAndTeam in
                self?.openUserProfile(employeeAndTeam)
            })
            .disposed(by: bag)
        
        router.setRootModule(searchController)
        
        return searchViewModel.modelResult
    }
}
