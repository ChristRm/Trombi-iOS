//
//  ViewController.swift
//  Trombi
//
//  Created by Christian Rusin  on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
    }

    func getAllData() {
        do {
            try URLSession.shared.dataTask(with:
            TrombiApiRequests.getPersons.asURLRequest()) { (data, response, error) in
                if let _ = error {
                    // TODO: error handling
                } else if let personsData = data {
                    do {
                        let decoder = JSONDecoder()
                        let _ = try decoder.decode(Array<Employee>.self,
                                                   from: personsData)// TODO: employees list to handle
                    } catch {

                    }

                    // TODO: data came case
                } else {
                    // TODO: else case
                }
            }
        } catch {
            print("Shit something went wrong")
        }
    }

}
