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

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Input
    
    private(set) var lastUpdatedTagCell: BehaviorRelay<FilterTagCellModel?> = BehaviorRelay<FilterTagCellModel?>(value: nil)
    
    // MARK: - Output
    var filtersSections: Driver<[FiltersSection]> { return _filtersSections.asDriver() }
    var filteredTeams: Driver<Set<Team> > { return _filteredTeams.asDriver() }
    var newcomersFilterSelected: Driver<Bool> { return _newcomersFilterSelected.asDriver() }

    // 2 combineLatests in order to make a bindings instead
    var filtered: Driver<Bool> {
        return Observable.combineLatest(
            filteredTeams.asObservable(),
            _newcomersFilterSelected.asObservable()
        ).map({ [weak self] (filtered, selected) -> Bool in
            self?.setupTags()
            return !filtered.isEmpty || selected
        }).asDriver(onErrorJustReturn: false)
    }

    private let _filteredTeams: BehaviorRelay<Set<Team> > = BehaviorRelay<Set<Team> >(value: Set<Team>())
    private let _filtersSections = BehaviorRelay<[FiltersSection]>(value: [])
    private let _newcomersFilterSelected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    var teams: [Team] {
        didSet {
            setupTags()
        }
    }

    init(teams: [Team]) {
        self.teams = teams
        
        lastUpdatedTagCell.map({ [weak self] newcomersTagCell -> Bool in
            guard let strongSelf = self else {
                fatalError("FilterViewViewModel shouldn't be nil here")
            }

            guard let tagCell = newcomersTagCell else {
                return strongSelf._newcomersFilterSelected.value
                // no cell selected, we fallback to existing value
            }
            
            switch tagCell.type {
            case .team(_):
                return strongSelf._newcomersFilterSelected.value
            case .newcomers:
                return tagCell.selected
            }
        }).bind(to: _newcomersFilterSelected).disposed(by: disposeBag)

        lastUpdatedTagCell.map({ [weak self] tagCell -> Set<Team> in
            guard let strongSelf = self else {
                fatalError("FilterViewViewModel shouldn't be nil here")
            }

            guard let tagCell = tagCell else {
                return strongSelf._filteredTeams.value
                // if teamTagCell is nil it means the type of cell is not team so we fallback to existing value
            }

            var newFilteredTeams = strongSelf._filteredTeams.value
            
            switch tagCell.type {
            case .team(let team):
                if tagCell.selected {
                    newFilteredTeams.insert(team)
                } else {
                    newFilteredTeams.remove(team)
                }
                return newFilteredTeams
            case .newcomers:
                return newFilteredTeams
            }
        }).bind(to: _filteredTeams).disposed(by: disposeBag)

        setupTags()
    }

    // MARK: - Public interface

    func resetFilters() {
        _filteredTeams.accept(Set<Team>())
        _newcomersFilterSelected.accept(false)
    }

    // MARK: - Private methods
    private func setupTags() {
        var tags: [FiltersSection] = []

        var section1Tags: [FilterTagCellModel] = []
        section1Tags.append(
            FilterTagCellModel(
                title: "Newcomers",
                selected: _newcomersFilterSelected.value,
                type: .newcomers
            )
        )

        tags.append(
            FiltersSection(header: FilterCategory.people.title, items: section1Tags)
        )

        var section2Tags: [FilterTagCellModel] = []
        section2Tags = teams.compactMap { team in
            return FilterTagCellModel(
                title: team.name,
                selected: _filteredTeams.value.contains(where: { $0 == team  }),
                type: .team(team)
            )
        }

        tags.append(
            FiltersSection(header: FilterCategory.team.title, items: section2Tags)
        )
        
        // TODO: bind instead
        _filtersSections.accept(tags)
    }
}

extension FiltersViewViewModel {
    
    fileprivate enum FilterCategory {
        case people
        case team
        
        var title: String {
            switch self {
            case .people:
                return "BY PEOPLE"
            case .team:
                return "BY DEPARTMENT"
            }
        }
    }
}
