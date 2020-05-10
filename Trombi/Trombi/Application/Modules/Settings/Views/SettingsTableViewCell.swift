//
//  SettingsTableViewCell.swift
//  Trombi
//
//  Created by Christian Rusin on 30/03/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet private weak var settingNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setNameLabel(_ nameLabel: String) {
        settingNameLabel.text = nameLabel
    }
}
