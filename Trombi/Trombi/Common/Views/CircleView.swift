//
//  CircleView.swift
//  Trombi
//
//  Created by Chris Rusin on 3/10/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class CircleView: UIView {

    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = .clear // the color applied to the shadowLayer, rather than the view's backgroundColor

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = bounds.height / 2.0
        layer.cornerRadius = cornerRadius

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            shadowLayer.shadowOpacity = 0.7
            shadowLayer.shadowRadius = 9

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
