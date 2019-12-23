//
//  EmployeeTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/8/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

struct EmployeeSearchCellModel {
    let imageUrl: String
    let nameText: String
    let positionText: String
    let teamNameText: String
}

final class EmployeeSearchTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var avatarImageView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var positionLabel: UILabel?
    @IBOutlet private weak var teamLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView?.layer.cornerRadius = 40.0
        avatarImageView?.layer.masksToBounds = true
    }

    func setModel(_ model: EmployeeSearchCellModel) {
        let avatarUrl = TrombiApiRequests.baseUrl + model.imageUrl
        avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)

        nameLabel?.text = model.nameText
        teamLabel?.text = model.teamNameText
        positionLabel?.text = model.positionText
    }
}
