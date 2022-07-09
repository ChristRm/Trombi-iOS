//
//  UsefulLinkTableViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/23/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

public struct UsefulLinkCellModel {
    let imageUrl: String

    let title: String
    let description: String
}

class UsefulLinkTableViewCell: UITableViewCell {

    @IBOutlet private weak var linkImageView: UIImageView!
    @IBOutlet private weak var imageShadowView: UIView!
    @IBOutlet private weak var imageShadowInnerView: UIView!

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        initShadows()
    }

    func setModel(_ model: UsefulLinkCellModel) {
        if model.imageUrl.isEmpty {
            linkImageView?.image = UIImage(named: "defaultLink")
        } else {
            linkImageView?.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: UIImage(named: "defaultLink"), completed: nil)
        }

        titleLabel?.text = model.title
        descriptionLabel?.text = model.description
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        linkImageView?.layer.cornerRadius = bounds.width * CGFloat(0.03)
        imageShadowInnerView?.layer.cornerRadius = bounds.width * CGFloat(0.03)
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
