//
//  UsefulLinkTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/23/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

struct UsefulLinkCellModel {
    let imageUrl: String

    let title: String
    let description: String
}

final class UsefulLinkTableViewCell: UITableViewCell {

    @IBOutlet private weak var shadowedImageView: ShadowedImageView?
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?

    func setModel(_ model: UsefulLinkCellModel) {
        if model.imageUrl.isEmpty {
//            linkImageView?.image = UIImage(named: "defaultLink")
            shadowedImageView?.setImage(UIImage(named: "defaultLink")!)
        } else {
            shadowedImageView?.setImage(with: URL(string: model.imageUrl), completed: nil)
//            linkImageView?.sd_setImage(with: URL(string: model.imageUrl), completed: nil)
        }

        titleLabel?.text = model.title
        descriptionLabel?.text = model.description
    }
}
