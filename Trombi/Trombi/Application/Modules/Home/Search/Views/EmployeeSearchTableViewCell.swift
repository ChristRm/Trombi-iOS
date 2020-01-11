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
    @IBOutlet private weak var imageShadowView: UIView?
    @IBOutlet private weak var imageShadowInnerView: UIView?

    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var positionLabel: UILabel?
    @IBOutlet private weak var teamLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView?.layer.cornerRadius = 40.0
        avatarImageView?.layer.masksToBounds = true

        initShadows()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageBounds = imageShadowView?.bounds else { return }
        imageShadowView?.layer.shadowPath = UIBezierPath(
            roundedRect: imageBounds, cornerRadius: imageBounds.height / 2.0
            ).cgPath
    }

    func setModel(_ model: EmployeeSearchCellModel) {
        let avatarUrl = TrombiApiRequests.baseUrl + model.imageUrl
        avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)

        nameLabel?.text = model.nameText
        teamLabel?.text = model.teamNameText
        positionLabel?.text = model.positionText
    }

    // MARK: - Private
    private func initShadows() {

        // shadow around image view
        imageShadowView?.layer.shadowColor = UIColor.black.cgColor
        imageShadowView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageShadowView?.layer.shadowOpacity = 0.4
        imageShadowView?.layer.shadowRadius = 5.0
    }
}
