//
//  FiltersViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 1/19/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class FiltersViewViewModel {

    enum FilterCategory: Int {
        case people = 0
        case department = 1
    }

    // MARK: - Properties

    var newcomersFilterSelected: Driver<Bool> { return _newcomersFilterSelected.asDriver() }
    var filteredTeams: Driver<Set<Team> > { return _filteredTeams.asDriver() }

    var numberOfSections: Int {
        return _sectionsTags.value.keys.count
    }

    var tagSectionTitles: [String] {
        return ["BY PEOPLE", "BY DEPARTMENT"]
    }

    func numberOfRows(section: Int) -> Int {
        return _sectionsTags.value[section]!.count
    }

    private var _newcomersFilterSelected: BehaviorRelay<Bool>
    private var _filteredTeams: BehaviorRelay<Set<Team> >

    var sectionsTags: Driver<[Int: [TagCellViewModel]]> { return _sectionsTags.asDriver() }

    private let _sectionsTags = BehaviorRelay<[Int: [TagCellViewModel]]>(value: [:])

    let teams: [Team]

    init(teams: [Team], filteredByNewcomers: Bool, filteredTeams: Set<Team>) {
        self.teams = teams
        _newcomersFilterSelected = BehaviorRelay(value: filteredByNewcomers)
        _filteredTeams = BehaviorRelay(value: filteredTeams)
        setupTags()
    }

    // MARK: - Public interface

    func resetFilters() {
        _filteredTeams.accept(Set<Team>())
        _newcomersFilterSelected.accept(false)
        setupTags()
    }

    func viewModelForTag(_ indexPath: IndexPath) -> TagCellViewModel {
        return _sectionsTags.value[indexPath.section]![indexPath.row]
    }

    func didChangeTagAt(_ indexPath: IndexPath, selected: Bool) {
        guard let filterCategory = FilterCategory(rawValue: indexPath.section) else {
            fatalError("Selected tag does not belong to any category (NumberOfCategories==NumberOfSections)")
        }

        switch filterCategory {
        case .people:
            _newcomersFilterSelected.accept(selected)
        case .department:
            var newFilteredTeams = _filteredTeams.value
            if selected {
                newFilteredTeams.insert(teams[indexPath.row])
                _filteredTeams.accept(newFilteredTeams)
            } else {
                newFilteredTeams.remove(teams[indexPath.row])
                _filteredTeams.accept(newFilteredTeams)
            }
        }

        setupTags()
    }

    // MARK: - Private methods
    func setupTags() {
        var tags: [Int: [TagCellViewModel]] = [:]

        var section1Tags: [TagCellViewModel] = []
        section1Tags.append(TagCellViewModel(title: "Newcomers", selected: _newcomersFilterSelected.value, type: .other))

        tags[FilterCategory.people.rawValue] = section1Tags

        var section2Tags: [TagCellViewModel] = []
        section2Tags = teams.compactMap { team in
            return TagCellViewModel(title: team.name,
                                    selected: _filteredTeams.value.contains(where: { $0 == team  }),
                                    type: .department) }

        tags[FilterCategory.department.rawValue] = section2Tags

        _sectionsTags.accept(tags)
    }
}