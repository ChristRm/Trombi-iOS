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

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    var filtersViewViewModel: FiltersViewViewModel {
        let result = FiltersViewViewModel(teams: applicationData.teams,
                                          filteredByNewcomers: filteredByNewcomers,
                                          filteredTeams: filteredTeams)

        result.filteredTeams.drive(onNext: { [weak self] filteredTeams in
            self?.filteredTeams = filteredTeams
        }).disposed(by: disposeBag)

        result.newcomersFilterSelected.drive(onNext: { [weak self] newcomersFilterSelected in
            self?.filteredByNewcomers = newcomersFilterSelected
        }).disposed(by: disposeBag)

        return result
    }

    var applicationData: ApplicationData = ApplicationData() {
        didSet {
            _employees.accept(employeesCellViewModels(from: applicationData))
        }
    }

    var employees: Driver<[EmployeeCellViewModel]> { return _employees.asDriver() }
    var numberOfEmployees: Int { return _employees.value.count }

    private let _employees = BehaviorRelay<[EmployeeCellViewModel]>(value: [])

    private var filteredTeams: Set<Team> = Set<Team>() {
        didSet {
            _employees.accept(employeesCellViewModels(from: applicationData))
        }
    }

    private var filteredByNewcomers: Bool = false {
        didSet {
            _employees.accept(employeesCellViewModels(from: applicationData))
        }
    }

    // MARK: Public methods
    
    func viewModelForEmployee(at index: Int) -> EmployeeCellViewModel {
        return _employees.value[index]
    }

    // MARK: - Private

    private func employeesCellViewModels(from applicationData: ApplicationData) -> [EmployeeCellViewModel] {
        let teams = applicationData.teams

        return applicationData.employees.compactMap { employee in
            guard let team =
                teams.filter({ $0.identifier == employee.teamId }).filter({
                    return filteredTeams.isEmpty || filteredTeams.contains($0)
                }).first else {
                return nil
            }

            let teamName = team.name

            if filteredByNewcomers {
                if employee.arrival < Date().addingTimeInterval(-100) {
                    return nil
                }
            }
            return EmployeeCellViewModel(imageUrl: employee.avatarUrl,
                                         nameText: employee.name,
                                         teamNameText: teamName,
                                         positionText: employee.job)
        }
    }
}
