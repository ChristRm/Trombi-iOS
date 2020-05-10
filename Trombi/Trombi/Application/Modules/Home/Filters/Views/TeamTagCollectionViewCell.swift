//
//  TeamTagCollectionViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 1/19/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class TeamTagCollectionViewCell: UICollectionViewCell {
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

    // MARK: - Private

    private func configure() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(redInt: 226, greenInt: 222, blueInt: 221, alpha: 1.0).cgColor
    }

    private func setSelected(_ selected: Bool) {
        backgroundColor = selected ? .mainBlackColor : .clear
        titleLabel?.textColor = selected ? .white : UIColor.mainBlackColor
        layer.borderWidth = selected ? 0.0 : 1.0
        layer.borderColor = selected ? UIColor.clear.cgColor :
            UIColor(redInt: 226, greenInt: 222, blueInt: 221, alpha: 1.0).cgColor
    }
}
