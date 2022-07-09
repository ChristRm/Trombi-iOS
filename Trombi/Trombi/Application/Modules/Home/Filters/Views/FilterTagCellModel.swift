//
//  FilterTagCellModel.swift
//  Trombi
//
//  Created by Chris Rusin on 2/13/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation

public struct FilterTagCellModel {
    enum CellType {
        case newcomers
        case team(Team)
    }
    
    var title: String
    var selected: Bool
    var type: CellType
}
