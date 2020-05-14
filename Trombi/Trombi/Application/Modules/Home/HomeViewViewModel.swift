//
//  HomeViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - Constants
extension HomeViewViewModel {
}

final class HomeViewViewModel {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    var filtersViewViewModel: FiltersViewViewModel = FiltersViewViewModel(teams: [])

    var applicationData: ApplicationData = ApplicationData() {
        didSet {
            filtersViewViewModel.teams = applicationData.teams
            // subscribe to updates from filter panel and genrerate filtered data
            Observable.combineLatest(
                filtersViewViewModel.filteredTeams.asObservable(),
                filtersViewViewModel.newcomersFilterSelected.asObservable()
            ).map({ (filteredTeams, newcomersFilterSelected) -> [EmployeesSection] in
                return self.getEemployeesSections(filteredTeams: filteredTeams, sortByNewcomers: newcomersFilterSelected)
                }).bind(to: _employeesSections).disposed(by: disposeBag)
        }
    }
    // MARK: - Output
    var employeesSections: Driver<[EmployeesSection]> { return _employeesSections.asDriver() }

    // MARK: - Private properties

    private let _employeesSections = BehaviorRelay<[EmployeesSection]>(value: [])
}

// MARK: - Private interface
extension HomeViewViewModel {

    fileprivate func getEemployeesSections(
        filteredTeams: Set<Team>,
        sortByNewcomers: Bool
    ) -> [EmployeesSection] {
        let filteredEmployees = filterEmployees(applicationData.employees, filteredTeams: filteredTeams)
        let sortedEmployees = sortEmployeesBySections(filteredEmployees, sortByNewcomers: sortByNewcomers)

        return sortedEmployees
    }

    private func sortEmployeesBySections(_ employees: [Employee], sortByNewcomers: Bool) -> [EmployeesSection] {
        var result: [EmployeesSection] = []

        if sortByNewcomers {
            let newcomers = employees.filter { $0.isNewcomer }
            if !newcomers.isEmpty {
                result.append(
                    EmployeesSection(
                        header: "Newcomers",
                        rightSideImage: UIImage(named: "sayHi") ?? nil,
                        items: newcomers.map({ employeeInfo($0) }))
                )
            }
        }

        alphabet.forEach { letter in

            var employeesStartedWithLetter = employees.filter {
                //do not include newcomers as they if they are filtered to another section already
                if sortByNewcomers && $0.isNewcomer {
                    return false
                } else {
                    return $0.surname.first == letter
                }
            }
            employeesStartedWithLetter = employeesStartedWithLetter.sorted(by: { $0.surname < $1.surname })

            // return from loop closure if there is no employee starting with this letter
            guard !employeesStartedWithLetter.isEmpty else { return }
            let employeesSection = EmployeesSection(
                header: String(letter),
                rightSideImage: nil,
                items: employeesStartedWithLetter.map({ employeeInfo($0) })
            )

            result.append(employeesSection)
        }

        return result
    }

    private func filterEmployees(_ employees: [Employee], filteredTeams: Set<Team>) -> [Employee] {
        var filteredEmployees: [Employee] = employees

        if !filteredTeams.isEmpty {
            filteredEmployees = filteredEmployees.filter({
                if let teamOfEmployee = self.applicationData.teamOfEmployee($0) {
                    return filteredTeams.contains(teamOfEmployee)
                } else {
                    return false
                }
            })
        }

        return filteredEmployees
    }

    private func employeeInfo(_ employee: Employee) -> EmployeeCellModel {
        return EmployeeCellModel(
            employee: employee,
            team: applicationData.teamOfEmployee(employee)
        )
    }

    private var alphabet: [Character] {
        let startChar = Unicode.Scalar("A").value
        let endChar = Unicode.Scalar("Z").value

        let result: [Character] = (startChar...endChar).map { letterCode in
            guard let unicodeScalar = Unicode.Scalar(letterCode) else {
                fatalError("Cannot build Unicode.Scalar from alphabet letter code") }

            return Character(unicodeScalar)
        }

        return result
    }
}
