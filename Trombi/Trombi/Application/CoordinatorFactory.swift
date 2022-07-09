//
//  CoordinatorFactory.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import UIKit

public class CoordinatorFactory {
    public init() {}

    public static func router(_ navController: UINavigationController?) -> Router {
        RouterImp(rootController: navigationController(navController))
    }

    public static func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        navController ?? UINavigationController(rootViewController: UIViewController())
    }
    
    public func homeCoordinator(applicationData: ApplicationData) -> HomeCoordinator {
        return HomeCoordinator(applicationData: applicationData)
    }
}
