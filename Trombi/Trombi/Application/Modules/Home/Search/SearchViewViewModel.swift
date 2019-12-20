//
//  SearchViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 8/24/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewViewModel {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Properties

    let applicationData: ApplicationData

    // MARK: - Input
    var enteredSearch: BehaviorRelay = BehaviorRelay<String>(value: "")

    // MARK: - Output
    var tableOfFoundEmployees: Driver<[EmployeeSearchCellModel]> { return _foundEmployees.asDriver() }
    var noResultsIsHidden: Driver<Bool> { return _noResultsIsHidden.asDriver() }

    // MARK: - Private properties
    private let _foundEmployees = BehaviorRelay<[EmployeeSearchCellModel]>(value: [])
    private let _noResultsIsHidden = BehaviorRelay<Bool>(value: true)

    private let searchService: SearchService

    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
        self.searchService = SearchService(employees: applicationData.employees)
        setup()
    }

    private func setup() {
        enteredSearch.distinctUntilChanged().map({ [weak self] enteredText -> [EmployeeSearchCellModel] in
            guard let strongSelf = self else { return [] }

            print(enteredText)
            return strongSelf.searchEmployee(searchFragment: enteredText)
        }).bind(to: _foundEmployees).disposed(by: disposeBag)

        Observable.combineLatest(_foundEmployees, enteredSearch) { (found, entered) -> Bool in
            let noResults = !entered.isEmpty && found.isEmpty
            return !noResults
        }.bind(to: _noResultsIsHidden).disposed(by: disposeBag)
    }

    private func searchEmployee(searchFragment: String) -> [EmployeeSearchCellModel] {
        let employees = searchService.search(fragmentString: searchFragment)
        return employees.map { employeeCellModel($0) }
    }

    private func employeeCellModel(_ employee: Employee) -> EmployeeSearchCellModel {
        return EmployeeSearchCellModel(
            imageUrl: employee.avatarUrl,
            nameText: employee.fullName,
            positionText: employee.job,
            teamNameText: applicationData.teamOfEmployee(employee).name
        )
    }
}
