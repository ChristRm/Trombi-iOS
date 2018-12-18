//
//  EmployeeTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

final class EmployeeTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var positionLabel: UILabel?
    @IBOutlet weak var teamLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
