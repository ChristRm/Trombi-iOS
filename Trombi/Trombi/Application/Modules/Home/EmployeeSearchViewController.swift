//
//  EmployeeSearchViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/18/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

final class EmployeeSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

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



    // MARK: - Private methods
//    private func setupTableView() {
//        tableView?.delegate = self
//        tableView?.dataSource = self
//    }

}
//
//// MARK: - UITableViewDelegate
//extension EmployeesViewController: UITableViewDelegate {
//
//}
//
//// MARK: - UITableViewDataSource
//extension EmployeesViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIdentifier,
//                                                       for: indexPath) as? EmployeeTableViewCell else {
//                                                        fatalError("Unexpected Table View Cell")
//        }
//
//        return cell
//    }
//}
