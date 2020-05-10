//
//  TeamsViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 4/20/20.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: TeamsViewViewModel? {
        didSet {
            if let viewModel = viewModel {
                print("This moment")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        let firstTeam = viewModel?.applicationData.teams.first

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
