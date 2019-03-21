//
//  CircleImageView.swift
//  Trombi
//
//  Created by Chris Rusin on 3/1/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2.0
    }

}
