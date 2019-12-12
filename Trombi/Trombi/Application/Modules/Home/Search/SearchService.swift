//
//  SearchService.swift
//  Trombi
//
//  Created by Chris Rusin on 10/28/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation

class SearchService {
    var employees: [Employee] = []

    init() { }

    init(employees: [Employee]) {
        self.employees = employees
    }

    func search(fragmentString: String) -> [Employee] {
            return employees.filter({ $0.fullName.contains(fragmentString) })
    }
}
