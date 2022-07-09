//
//  NSObject+Bundle.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import Foundation

extension NSObject {
    var nameOfClass: String {
        NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }

    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    class var bundle: Bundle {
        Bundle(for: self)
    }
}
