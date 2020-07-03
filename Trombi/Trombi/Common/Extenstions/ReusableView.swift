//
//  ReusableView.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

protocol ReusableView {

    static var staticReuseIdentifier: String { get }

}

extension ReusableView {

    static var staticReuseIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}
