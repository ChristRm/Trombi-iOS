//
//  JSONDecoder+TrombiAPI.swift
//  Trombi
//
//  Created by Chris Rusin on 8/17/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func decode<T>(
        _ type: T.Type,
        from data: Data
        ) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        return try decoder.decode(
            T.self,
            from: data
        )
    }
}
