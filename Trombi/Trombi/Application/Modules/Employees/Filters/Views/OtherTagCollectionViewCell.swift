//
//  OtherTagCollectionViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 1/26/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class OtherTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override var isSelected: Bool {
        didSet {
            setSelected(isSelected)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }

    // MARK: - Private

    private func configure() {
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(redInt: 255, greenInt: 242, blueInt: 217, alpha: 1.0).cgColor
    }

    private func setSelected(_ selected: Bool) {
        backgroundColor = selected ? .additionalGoldColor : .clear
        titleLabel?.textColor = selected ? .white : UIColor.mainBlackColor
        layer.borderWidth = selected ? 0.0 : 2.0
    }
}
