//
//  EmployeeSection.swift
//  Trombi
//
//  Created by Chris Rusin on 6/3/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit
import RxDataSources

public struct EmployeesSection: SectionModelType {
    public typealias Item = EmployeeCellModel
    
    public var header: String
    public let rightSideImage: UIImage?
    public var items: [Item]

    public init(original: EmployeesSection, items: [Item]) {
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
