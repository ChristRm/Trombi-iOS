//
//  UITableView+dequeueReusableCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

extension UITableView {

    func registerReusableCell<T: UITableViewCell>(type: T) {
        register(UINib(nibName: T.staticReuseIdentifier, bundle: nil), forCellReuseIdentifier: T.staticReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.staticReuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }

        return cell
    }

}
