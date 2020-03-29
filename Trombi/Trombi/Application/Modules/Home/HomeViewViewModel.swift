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

// MARK: - Constants
extension HomeViewViewModel {
    fileprivate enum Defaults {
        static let secondsInDay = 3600.0 * 24.0
        static let newcomerInterval: TimeInterval = 30.0 * secondsInDay
    }
}

final class HomeViewViewModel {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    var filtersViewViewModel: FiltersViewViewModel = FiltersViewViewModel(teams: [])

    var applicationData: ApplicationData = ApplicationData() {
        didSet {
            filtersViewViewModel.teams = applicationData.teams
            _employeesSections.accept(getEemployeesSections())
        }
    }

    var employeesSections: Driver<[EmployeesSection]> { return _employeesSections.asDriver() }

    // MARK: - Private properties

    private let _employeesSections = BehaviorRelay<[EmployeesSection]>(value: [])
    private var filteredTeams: Set<Team> = Set<Team>() {
        didSet {
            _employeesSections.accept(getEemployeesSections())
        }
    }

    private var sortByNewcomers: Bool = false {
        didSet {
            _employeesSections.accept(getEemployeesSections())
        }
    }

    // MARK: - Public interface

    init() {
        filtersViewViewModel.filteredTeams.drive(onNext: { teams in
            self.filteredTeams = Set<Team>(teams)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        filtersViewViewModel.newcomersFilterSelected.drive(onNext: { newcomers in
            self.sortByNewcomers = newcomers
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    func numberOfEmployeesSections() -> Int {
        return _employeesSections.value.count
    }

    func employeeSectionAtIndex(_ index: Int) -> EmployeesSection {
        return _employeesSections.value[index]
    }
}

// MARK: - Private interface
extension HomeViewViewModel {

    private typealias SortedEmployees = (section: String, employees: [Employee])

    fileprivate func getEemployeesSections() -> [EmployeesSection] {
        let filteredEmployees = filterEmployees(applicationData.employees)
        let sortedEmployees = sortEmployeesBySections(filteredEmployees)

        return sortedEmployees
    }

    private func sortEmployeesBySections(_ employees: [Employee]) -> [EmployeesSection] {
        var result: [EmployeesSection] = []

        if sortByNewcomers {
            let newcomers = employees.filter { isEmployeeNewcomer($0) }
            result.append(
                EmployeesSection(
                    title: "Newcomers",
                    rightSideImage: UIImage(named: "sayHi") ?? nil,
                    cells: newcomers.map({ employeeInfo($0) }))
            )
        }

        alphabet.forEach { letter in

            var employeesStartedWithLetter = employees.filter {
                //do not include newcomers as they if they are filtered to another section already
                if sortByNewcomers && isEmployeeNewcomer($0) {
                    return false
                } else {
                    return $0.surname.first == letter
                }
            }
            employeesStartedWithLetter = employeesStartedWithLetter.sorted(by: { $0.surname < $1.surname })

            // return from loop closure if there is no employee starting with this letter
            guard !employeesStartedWithLetter.isEmpty else { return }

            result.append(EmployeesSection(title: String(letter),
                                           rightSideImage: nil,
                                           cells: employeesStartedWithLetter.map({ employeeInfo($0) })))
        }

        return result
    }

    private func filterEmployees(_ employees: [Employee]) -> [Employee] {
        var filteredEmployees: [Employee] = employees

        if !filteredTeams.isEmpty {
            filteredEmployees = filteredEmployees.filter({
                let teamOfEmployee = self.applicationData.teamOfEmployee($0)
                return self.filteredTeams.contains(teamOfEmployee)
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

    private func isEmployeeNewcomer(_ employee: Employee) -> Bool {
        return employee.arrival > Date().addingTimeInterval(-Defaults.newcomerInterval)
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
