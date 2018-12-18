//
//  EmployeesViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class EmployeesViewViewModel {

    // MARK: - Properties
    var applicationData: ApplicationData = ApplicationData() {
        didSet {
            _employees.accept(employeesCellViewModels(from: applicationData))
        }
    }

    var employees: Driver<[EmployeeCellViewModel]> { return _employees.asDriver() }
    var numberOfEmployees: Int { return _employees.value.count }

    private let _employees = BehaviorRelay<[EmployeeCellViewModel]>(value: [])

    // MARK: Public methods
    
    func viewModelForEmployee(at index: Int) -> EmployeeCellViewModel {
        return _employees.value[index]
    }

    // MARK: - Private

    private func employeesCellViewModels(from applicationData: ApplicationData) -> [EmployeeCellViewModel] {
        let teams = applicationData.teams

        return applicationData.employees.compactMap { employee in
            let teamName = teams.first(where: { $0.identifier == employee.teamId })?.name ?? ""
            return EmployeeCellViewModel(imageUrl: employee.avatarUrl,
                                         nameText: employee.name,
                                         teamNameText: teamName,
                                         positionText: employee.job)
        }
    }
}
