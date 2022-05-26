//
//  UIViewController+xib.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        var identifier = String(describing: self)
        // If a class used with generic it returns whole name with generic
        // like ClassName<Generic>, to avoid this, here is cutting
        // only first part - class name
        if let cuttedIndex = identifier.firstIndex(of: "<") {
            identifier = String(identifier[..<cuttedIndex])
        }
        return identifier
    }
    
    var identifier: String {
        type(of: self).identifier
    }
}
