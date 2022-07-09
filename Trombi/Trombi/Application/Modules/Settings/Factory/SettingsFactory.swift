//
//  SettingsFactory.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import Foundation

public protocol SettingsFactoryInterface: AnyObject {
    func makeSettingsRootPresentable<ViewModel: SettingsViewViewModelInterface>(with viewModel: ViewModel) -> Presentable
}

public class SettingsFactory: SettingsFactoryInterface {
    public func makeSettingsRootPresentable<ViewModel: SettingsViewViewModelInterface>(with viewModel: ViewModel) -> Presentable {
        return SettingsViewController(viewModel: viewModel)
    }
}
