//
//  EmployeesCollectionViewHeader.swift
//  Trombi
//
//  Created by Chris Rusin on 7/3/20.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit

class EmployeesCollectionViewHeader: UICollectionReusableView {
        
    @IBOutlet private weak var descriptionLeftLabel: UILabel?
    @IBOutlet private weak var rightSideimageView: UIImageView?

    func setDescriptionLeftLabel(_ label: String) {
        self.descriptionLeftLabel?.text = label
    }

    func setRightSideImage(_ image: UIImage?) {
        self.rightSideimageView?.image = image
    }
}
