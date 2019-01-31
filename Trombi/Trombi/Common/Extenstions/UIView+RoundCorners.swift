//
//  UIView+RoundCorners.swift
//  Trombi
//
//  Created by Chris Rusin on 1/19/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
