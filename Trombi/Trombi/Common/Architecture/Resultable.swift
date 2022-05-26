//
//  Resultable.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import RxSwift

public protocol Resultable {
    associatedtype ValueType

    var modelResult: Single<ValueType> { get }
}
