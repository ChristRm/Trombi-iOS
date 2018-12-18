//
//  EmployeesViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

final class EmployeesViewViewModel {

    var applicationData: ApplicationData = ApplicationData() {
        didSet {
            print("Got it babe: Employees:\(applicationData.employees.count) Teams:\(applicationData.teams.count) Usefule links:\(applicationData.usefuleLinks.count)")
        }
    }
}
