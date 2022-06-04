//
//  HomeFactory.swift
//  Trombi
//
//  Created by Kristian Rusyn on 06/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import Foundation
import UIKit

public protocol HomeFactoryInterface: AnyObject {
    func makeHomeRootPresentable<ViewModel: HomeViewViewModelInterface>(with viewModel: ViewModel) -> Presentable
    
    func makeSearchScreenPresentable<ViewModel: SearchViewViewModelInterface>(with viewModel: ViewModel) -> Presentable
}

public class HomeFactory: HomeFactoryInterface {
    public func makeHomeRootPresentable<ViewModel: HomeViewViewModelInterface>(with viewModel: ViewModel) -> Presentable {
        return HomeViewController(viewModel: viewModel)
    }
    
    public func makeSearchScreenPresentable<ViewModel: SearchViewViewModelInterface>(with viewModel: ViewModel) -> Presentable {
        return SearchViewController(viewModel: viewModel)
    }
}
