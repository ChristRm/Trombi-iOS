//
//  MainTabBarViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

class MainTabBarViewViewModel {

    // MARK: - Public properties
//    private(set) var applicationData: (ApplicationData) -> Void

    // MARK: - Private properties
    private let employeesChainLoading = EmployeesChainLoading()
    private let teamsChainLoading = TeamsChainLoading()
    private let usefulLinksLoading = UsefulLinksChainLoading()

    // MARK: - Public interface
    func loadAppData() {
        let loadsChain = LoadsChain(chain: [employeesChainLoading, teamsChainLoading, usefulLinksLoading])

        loadsChain.executeChain({ (succeededLoads) in
            var applicationData = ApplicationData()
            applicationData.employees = self.employeesChainLoading.employees ?? []
            applicationData.teams = self.teamsChainLoading.teams ?? []
            applicationData.usefuleLinks = self.usefulLinksLoading.usefulLinks ?? []

        }) { (succeededLoads, error) in
            //TODO: handle
        }
    }
}
