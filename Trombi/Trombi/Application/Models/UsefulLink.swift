//
//  UsefulLink.swift
//  Trombi
//
//  Created by Chris Rusin on 12/1/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

struct UsefulLink: Codable {

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case url = "url"

        case title = "title"
        case description = "description"
        case imageUrl = "image_url"
    }

    var identifier: Int64

    var url: String
    var title: String
    var description: String

    var imageUrl: String
}
