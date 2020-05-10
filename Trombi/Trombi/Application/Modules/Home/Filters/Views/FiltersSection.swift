//
//  FiltersSection.swift
//  Trombi
//
//  Created by Christian Rusin on 06/05/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import RxDataSources

struct FiltersSection: SectionModelType {
    typealias Item = FilterTagCellModel
    
    var header: String
    var items: [Item]

    init(original: FiltersSection, items: [Item]) {
        self = original
        self.items = items
    }
    
    init(
        header: String,
        items: [Item]
    ) {
        self.header = header
        self.items = items
    }
}
