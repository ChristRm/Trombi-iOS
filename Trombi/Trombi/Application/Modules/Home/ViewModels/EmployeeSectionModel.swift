//
//  EmployeeSectionModel.swift
//  Trombi
//
//  Created by Chris Rusin on 6/3/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit
import RxDataSources

struct EmployeesSection: SectionModelType {
    typealias Item = EmployeeCellModel
    
    var header: String
    
    let rightSideImage: UIImage?
    
    var items: [Item]

    init(original: EmployeesSection, items: [Item]) {
        self = original
        self.items = items
    }
    
    init(
        header: String,
        rightSideImage: UIImage?,
        items: [Item]
    ) {
        self.header = header
        self.rightSideImage = rightSideImage
        self.items = items
    }
}
