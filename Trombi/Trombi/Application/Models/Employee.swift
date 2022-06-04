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
        case avatarUrl = "picture"

        case email = "email"
        case job = "job"
        case birthday = "birthday"
        case login = "login"
    }

    var identifier: Int64
    var teamId: Int64?

    var arrival: Date
    var surname: String
    var name: String

    var skype: String = ""
    var phone: String = ""

    var avatarUrl: String

    var email: String?
    var job: String
    var birthday: Date
    var login: String

    var fullName: String {
        return "\(name) \(surname)"
    }
}

public extension Employee {
    fileprivate enum Defaults {
        static let secondsInDay = 3600.0 * 24.0
        static let newcomerInterval: TimeInterval = 30.0 * secondsInDay
    }

    var isNewcomer: Bool {
        return arrival > Date().addingTimeInterval(-Defaults.newcomerInterval)
    }
}
