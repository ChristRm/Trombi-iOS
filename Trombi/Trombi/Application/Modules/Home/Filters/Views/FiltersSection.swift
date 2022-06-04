//
//  FiltersSection.swift
//  Trombi
//
//  Created by Christian Rusin on 06/05/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import RxDataSources

public struct FiltersSection: SectionModelType {
    public typealias Item = FilterTagCellModel
    
    public var header: String
    public var items: [Item]

    public init(original: FiltersSection, items: [Item]) {
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
