//
//  TrombiAPI.swift
//  Trombi
//
//  Created by Chris Rusin on 12/3/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation
import RxSwift

final class TrombiAPI {

    static let sharedAPI = TrombiAPI()

    func getEmployees() -> Observable<[Employee]> {
        let request = TrombiApiRequests.getPersons.asURLRequest()

        return URLSession.shared.rx.data(request: request).map({ data in
            return try JSONDecoder.decode(
                Array<Employee>.self,
                from: data
            )
        })
    }

    func getTeams() -> Observable<[Team]> {
        let request = TrombiApiRequests.getTeams.asURLRequest()

        return URLSession.shared.rx.data(request: request).map({ data in
            return try JSONDecoder.decode(
                Array<Team>.self,
                from: data
            )
        })
    }

    func getUsefulLinks() -> Observable<[UsefulLink]> {
        let request = TrombiApiRequests.getUsefulLinks.asURLRequest()
        return URLSession.shared.rx.data(request: request).map({ data in
            return try JSONDecoder.decode(
                Array<UsefulLink>.self,
                from: data
            )
        })
    }
}
