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
                if let error = error {
                    // TODO: error handling
                }  else if let data = data {
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
