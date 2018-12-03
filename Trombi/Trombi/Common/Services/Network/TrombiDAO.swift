//
//  TrombiDAO.swift
//  Trombi
//
//  Created by Chris Rusin on 12/3/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

class TrombiDAO {

    static func getEmployees() {
        do {
            let request = try TrombiApiRequests.getPersons.asURLRequest()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }

                if let _ = error {
                    // TODO: error handling
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970

                        let persons = try decoder.decode(Array<Employee>.self,
                                                         from: personsData)

                        print(persons)
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

    static func getTeams() {
        do {
            let request = try TrombiApiRequests.getTeams.asURLRequest()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }

                if let _ = error {
                    // TODO: error handling
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970

                        let persons = try decoder.decode(Array<Team>.self,
                                                         from: personsData)

                        print(persons)
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

    static func getUsefulLinks() {
        do {
            let request = try TrombiApiRequests.getUsefulLinks.asURLRequest()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }

                if let _ = error {
                    // TODO: error handling
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970

                        let persons = try decoder.decode(Array<UsefulLink>.self,
                                                         from: personsData)

                        print(persons)
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
