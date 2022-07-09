//
//  Team.swift
//  Trombi
//
//  Created by Chris Rusin on 12/1/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

public struct Team: Codable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {

        case identifier = "id"
        case name = "name"
        case members = "persons"

        case higherTeamlId = "higher_teaml_id"
    }

    var identifier: Int64
    var name: String

    var members: [String]

    var higherTeamlId: Int64?

    
}
