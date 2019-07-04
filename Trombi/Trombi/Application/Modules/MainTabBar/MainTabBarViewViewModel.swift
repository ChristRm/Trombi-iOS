//
//  MainTabBarViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MainTabBarViewViewModel {

    // MARK: - Properties

    private(set) var employeesViewViewModel: HomeViewViewModel = HomeViewViewModel()

    // MARK: - Private properties
    private let employeesChainLoading = EmployeesChainLoading()
    private let teamsChainLoading = TeamsChainLoading()
    private let usefulLinksLoading = UsefulLinksChainLoading()

    // MARK: - Public interface

    var employees: Driver<[Employee]> { return _employees.asDriver() }

    var randomUser: Employee {
        return _employees.value.first!
    }

    private let _employees = BehaviorRelay<[Employee]>(value: [])


    func loadAppData() {
        let loadsChain = LoadsChain(chain: [employeesChainLoading, teamsChainLoading, usefulLinksLoading])

        loadsChain.executeChain({ [weak self] succeededLoads in
            guard let strongSelf = self else { return }

            let result = ApplicationData()
            result.employees = strongSelf.employeesChainLoading.employees ?? []
            result.teams = strongSelf.teamsChainLoading.teams ?? []
            result.usefuleLinks = strongSelf.usefulLinksLoading.usefulLinks ?? []

            strongSelf.employeesViewViewModel.applicationData = result

            self?._employees.accept(result.employees)
        }) { (succeededLoads, error) in
            //TODO: handle errors
        }
    }
}
