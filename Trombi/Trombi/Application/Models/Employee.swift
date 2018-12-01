//
//  Employee.swift
//  Trombi
//
//  Created by Chris Rusin on 12/1/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

struct Employee: Codable {

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case teamId = "team_id"

        case arrival = "arrival"
        case surname = "surname"
        case name = "name"

        case email = "email"
        case job = "job"
        case birthday  = "birthday"
        case login = "login"
    }

    var identifier: Int64
    var teamId: Int64

    var arrival: Date
    var surname: String
    var name: String

    var email: String
    var job: String
    var birthday: Date
    var login: String
}
