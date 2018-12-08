//
//  TrombiDAO.swift
//  Trombi
//
//  Created by Chris Rusin on 12/3/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

class TrombiDAO {

    static func getEmployees(success: @escaping ([Employee]) -> Void, failure: @escaping (Error) -> Void) {
        do {
            let request = try TrombiApiRequests.getPersons.asURLRequest()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }

                if let error = error {
                    failure(error)
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970

                        let employees = try decoder.decode(Array<Employee>.self,
                                                         from: personsData)

                        print(employees)
                        success(employees)
                    } catch {
                        print("Unable to Decode JSON Response \(error)")
                        // TODO: catch case
                    }
                } else {
                    // TODO: else case
                }
                }.resume()
        } catch {
            print("Shit something went wrong")
        }
    }

    static func getTeams(success: @escaping ([Team]) -> Void, failure: @escaping (Error) -> Void) {
        do {
            let request = try TrombiApiRequests.getTeams.asURLRequest()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }

                if let error = error {
                    failure(error)
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970

                        let teams = try decoder.decode(Array<Team>.self,
                                                         from: personsData)

                        print(teams)
                        success(teams)
                    } catch {
                        print("Unable to Decode JSON Response \(error)")
                    }
                } else {
                    // TODO: else case
                }
                }.resume()
        } catch {
            print("Shit something went wrong")
        }
    }

    static func getUsefulLinks(success: @escaping ([UsefulLink]) -> Void, failure: @escaping (Error) -> Void) {
        do {
            let request = try TrombiApiRequests.getUsefulLinks.asURLRequest()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }

                if let error = error {
                    failure(error)
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970

                        let usefulLinks = try decoder.decode(Array<UsefulLink>.self,
                                                         from: personsData)

                        print(usefulLinks)
                        success(usefulLinks)
                    } catch {
                        print("Unable to Decode JSON Response \(error)")
                    }
                } else {
                    // TODO: else case
                }
                }.resume()
        } catch {
            print("Shit something went wrong")
        }
    }
}
