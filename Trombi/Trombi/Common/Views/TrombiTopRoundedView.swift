//
//  TrombiTopRoundedView.swift
//  Trombi
//
//  Created by Chris Rusin on 3/1/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

class TrombiTopRoundedView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight], radius: 19.0)
    }
}
