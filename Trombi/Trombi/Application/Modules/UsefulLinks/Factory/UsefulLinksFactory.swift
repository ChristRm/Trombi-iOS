//
//  UsefulLinksFactory.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import Foundation
public protocol UsefulLinksFactoryInterface: AnyObject {
    func makeUsefulLinksRootPresentable<ViewModel: UsefulLinksViewViewModelInterface>(with viewModel: ViewModel) -> Presentable
}

public class UsefulLinksFactory: UsefulLinksFactoryInterface {
    public func makeUsefulLinksRootPresentable<ViewModel: UsefulLinksViewViewModelInterface>(with viewModel: ViewModel) -> Presentable {
        return UsefulLinksViewController(viewModel: viewModel)
    }
}
