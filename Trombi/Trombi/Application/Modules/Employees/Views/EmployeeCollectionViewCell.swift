//
//  EmployeeCollectionViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/18/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import SDWebImage

struct EmployeeCellViewModel {

    init(imageUrl: String, nameText: String, teamNameText: String, positionText: String) {
        self.imageUrl = imageUrl
        self.nameText = nameText
        self.teamNameText = teamNameText
        self.positionText = positionText
    }

    var imageUrl: String = ""
    var nameText: String = ""
    var teamNameText: String = ""
    var positionText: String = ""
}

final class EmployeeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var imageShadowView: UIView?
    // to fill content of shadow view(when shadow view is transparent and has no content it does not draw the shadow)
    @IBOutlet private weak var imageShadowInnerView: UIView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var positionLabel: UILabel?
    @IBOutlet private weak var teamLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        initShadows()
    }

    func setModel(_ model: EmployeeCellViewModel) {
        let avatarUrl = TrombiApiRequests.baseUrl + model.imageUrl
        imageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)

        nameLabel?.text = model.nameText
        teamLabel?.text = model.teamNameText
        positionLabel?.text = model.positionText
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.cornerRadius = bounds.width * CGFloat(0.06)
        imageShadowInnerView?.layer.cornerRadius = bounds.width * CGFloat(0.06)
    }

    // MARK: - Private
    private func initShadows() {

        // shadow around image view
        imageShadowView?.layer.shadowColor = UIColor.black.cgColor
        imageShadowView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageShadowView?.layer.shadowOpacity = 0.4
        imageShadowView?.layer.shadowRadius = 5.0

        // shadow for team label over the image
        teamLabel?.layer.shadowColor = UIColor.black.cgColor
        teamLabel?.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        teamLabel?.layer.shadowOpacity = 0.65
        teamLabel?.layer.shadowRadius = 5.0
    }
}