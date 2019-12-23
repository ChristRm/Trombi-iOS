//
//  LastSearchTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/15/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class LastSearchTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var searchTextLabel: UILabel?

    func setText(_ text: String) {
        searchTextLabel?.text = text
    }
}
