//
//  UserInfoTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 2/10/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

public typealias EmployeeAndTeam = (Employee, Team)

protocol UserProfilePresenting {
    func openUserProfile(_ employeeAndTeam: EmployeeAndTeam?)
}

extension UserProfilePresenting where Self: RxBaseCoordinator<Any> {
    func openUserProfile(_ employeeAndTeam: EmployeeAndTeam?) {
        if let employee = employeeAndTeam?.0, let team = employeeAndTeam?.1 {
            let employeeViewController =
            EmployeeProfileViewController.modal(
                employee: employee,
                team: team,
                onDismiss: nil)
            
            router.present(employeeViewController)
        }
    }
}
