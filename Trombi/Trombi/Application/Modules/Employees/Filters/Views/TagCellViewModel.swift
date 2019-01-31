//
//  TagCellViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 2/13/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation

struct TagCellViewModel {
    enum CellType {
        case other
        case department
    }

    var title: String
    var selected: Bool
    var type: CellType
}
