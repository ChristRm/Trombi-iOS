//
//  ApplicationData.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

public class ApplicationData {

    init(employees: [Employee] = [], teams: [Team] = [], usefuleLinks: [UsefulLink] = []) {
        self.employees = employees
        self.teams = teams
        self.usefuleLinks = usefuleLinks
    }

    var employees: [Employee]
    var teams: [Team]
    var usefuleLinks: [UsefulLink]

    func teamOfEmployee(_ employee: Employee) -> Team? {
        return teams.first(where: { $0.identifier == employee.teamId })
    }
}
