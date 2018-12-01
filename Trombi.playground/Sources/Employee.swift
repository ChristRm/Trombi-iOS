//
//  Employee.swift
//  Trombi
//
//  Created by Chris Rusin on 12/1/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

public struct Employee: Codable {

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

    public var identifier: Int64
    public var teamId: Int64

    public var arrival: Date
    public var surname: String
    public var name: String

    public var email: String
    public var job: String
    public var birthday: Date
    public var login: String
}
