//
//  Presentable.swift
//  Trombi
//
//  Created by Kristian Rusyn on 04/06/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import UIKit

public protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    public func toPresent() -> UIViewController? {
        self
    }
}
