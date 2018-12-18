//
//  StartRequest.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

final class EmployeesChainLoading: ChainLoadingProtocol {
    var employees: [Employee]?

    func loadData(_ resultHandler: LoadingResultHandler) {
        TrombiDAO.getEmployees(success: { [weak self] employees in
            self?.employees = employees
            resultHandler.success()
        }, failure: { error in
            resultHandler.failure(error)
        })
    }
}

final class TeamsChainLoading: ChainLoadingProtocol {
    var teams: [Team]?

    func loadData(_ resultHandler: LoadingResultHandler) {
        TrombiDAO.getTeams(success: { [weak self] teams in
            self?.teams = teams
            resultHandler.success()
            }, failure: { error in
                resultHandler.failure(error)
        })
    }
}

final class UsefulLinksChainLoading: ChainLoadingProtocol {
    var usefulLinks: [UsefulLink]?

    func loadData(_ resultHandler: LoadingResultHandler) {
        TrombiDAO.getUsefulLinks(success: { [weak self] usefulLinks in
            self?.usefulLinks = usefulLinks
            resultHandler.success()
            }, failure: { error in
                resultHandler.failure(error)
        })
    }
}
