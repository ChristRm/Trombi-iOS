//
//  UserInfoTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 2/10/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    // MARK: - IBoutlet
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var infoLabel: UILabel?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
