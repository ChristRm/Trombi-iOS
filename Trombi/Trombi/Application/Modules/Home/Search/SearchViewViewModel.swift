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
import RxDataSources

final class SearchViewViewModel {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Properties
    let applicationData: ApplicationData

    // MARK: - Input
    private(set) var enteredSearch: BehaviorRelay = BehaviorRelay<String>(value: "")
    private(set) var selectedItem: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)

    // MARK: - Output
    var noResultsIsHidden: Driver<Bool> { return _noResultsIsHidden.asDriver() }
    var searchTable: Driver<[SearchTableElementModel]> { return _searchTable.asDriver() }
    var openEmployee: Signal<(Employee, Team)?> { return _openEmployee.asSignal(onErrorJustReturn: nil) }

    var forcedSearchText: Driver<String?> { return _forcedSearchText.asDriver() }

    // MARK: - Private properties
    private let _foundEmployeesTable = BehaviorRelay<[EmployeeSearchCellModel]>(value: [])
    private let _noResultsIsHidden = BehaviorRelay<Bool>(value: true)

    private let searchService: SearchService
    private let _searchTable =
        BehaviorRelay<[SearchTableElementModel]>(value: [])

    private let _openEmployee = BehaviorRelay<(Employee, Team)?>(value: nil)
    private let _forcedSearchText =
        BehaviorRelay<String?>(value: nil)


    private var foundEmployees: [Employee] = []

    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
        self.searchService = SearchService(employees: applicationData.employees)
        setup()
    }

    private func setup() {
        enteredSearch.distinctUntilChanged().map({ [weak self] enteredText -> [EmployeeSearchCellModel] in
            guard let strongSelf = self else { return [] }

            return strongSelf.searchEmployee(searchFragment: enteredText)
        }).bind(to: _foundEmployeesTable).disposed(by: disposeBag)

        Observable.combineLatest(_foundEmployeesTable, enteredSearch) { (foundEmployees, entered) -> [SearchTableElementModel] in
            guard !entered.isEmpty else {
                return UserDefaults.lastSearches.map { return SearchTableElementModel.lastSearch($0) }
            }

            let foundEmployeesTable = foundEmployees.map({ return SearchTableElementModel.employee($0) })
            return foundEmployeesTable
            }.bind(to: _searchTable).disposed(by: disposeBag)

        Observable.combineLatest(_foundEmployeesTable, enteredSearch) { (found, entered) -> Bool in
            let noResults = !entered.isEmpty && found.isEmpty
            return !noResults
        }.bind(to: _noResultsIsHidden).disposed(by: disposeBag)

        selectedItem.subscribe { [weak self] event in
            switch event {
            case .next(let row):
                if let row = row, let tableModel = self?._searchTable.value[row] {
                    switch tableModel {
                    case .employee(_):
                        if let selectedFoundEmployee = self?.foundEmployees[row],
                            let team = self?.applicationData.teamOfEmployee(selectedFoundEmployee) {
                            self?._openEmployee.accept((selectedFoundEmployee, team))
                        }
                    case .lastSearch(let lastSearch):
                        self?._forcedSearchText.accept(lastSearch)
                    }
                }
            default: break
            }
        }.disposed(by: disposeBag)
    }

    private func searchEmployee(searchFragment: String) -> [EmployeeSearchCellModel] {
        foundEmployees = searchService.search(fragmentString: searchFragment)
        return foundEmployees.map { employeeCellModel($0) }
    }

    private func employeeCellModel(_ employee: Employee) -> EmployeeSearchCellModel {
        return EmployeeSearchCellModel(
            imageUrl: employee.avatarUrl,
            nameText: employee.fullName,
            positionText: employee.job,
            teamNameText: applicationData.teamOfEmployee(employee)?.name ?? "No team"
        )
    }

    // MARK: - Public interface

    func addLastSearch(_ lastSearch: String) {
        let lastSearches = UserDefaults.lastSearches

        var queue = Queue<String>(maximumSize: 3, incomingOrder: lastSearches)
        queue.push(lastSearch)

        UserDefaults.set(lastSearches: queue.queueArray)
    }
}
