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

protocol MainTabBarViewViewModelInterface {
    var homeViewViewModel: HomeViewViewModelInterface { get set }
    var usefulLinksViewViewModel: UsefulLinksViewViewModelInterface { get set }
    var settingsViewViewModel: SettingsViewViewModelInterface { get set }
}

final class MainTabBarViewViewModel: MainTabBarViewViewModelInterface {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    var homeViewViewModel: HomeViewViewModelInterface = HomeViewViewModel()
    var usefulLinksViewViewModel: UsefulLinksViewViewModelInterface = UsefulLinksViewViewModel()
    var settingsViewViewModel: SettingsViewViewModelInterface = SettingsViewViewModel()
}
