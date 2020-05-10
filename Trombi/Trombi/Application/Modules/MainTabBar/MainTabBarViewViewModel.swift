//
//  MainTabBarViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MainTabBarViewViewModel {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    private(set) var homeViewViewModel: HomeViewViewModel = HomeViewViewModel()
    private(set) var teamsViewViewModel: TeamsViewViewModel = TeamsViewViewModel()
    private(set) var usefulLinksViewViewModel: UsefulLinksViewViewModel = UsefulLinksViewViewModel()
    private(set) var settingsViewViewModel: SettingsViewViewModel = SettingsViewViewModel()
}
