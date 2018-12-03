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
        TrombiDAO.getEmployees()
        TrombiDAO.getTeams()
        TrombiDAO.getUsefulLinks()
    }
}
