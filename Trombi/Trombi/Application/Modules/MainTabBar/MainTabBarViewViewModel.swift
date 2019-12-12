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

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    private(set) var homeViewViewModel: HomeViewViewModel = HomeViewViewModel()

    // MARK: - Public interface

    func loadAppData() {
        let getEmployees = TrombiAPI.sharedAPI.getEmployees()
        let getTeams = TrombiAPI.sharedAPI.getTeams()
        let getUsefulLinks = TrombiAPI.sharedAPI.getUsefulLinks()

        Observable.zip(
            getEmployees,
            getTeams,
            getUsefulLinks,
            resultSelector: { (employees: [Employee], teams: [Team], usefulLinks: [UsefulLink]) in
                let applicationData = ApplicationData(
                    employees: employees,
                    teams: teams,
                    usefuleLinks: usefulLinks
                )

                self.homeViewViewModel.applicationData = applicationData
        }).subscribe().disposed(by: disposeBag)
        #warning("Handle the errors")
    }
}
