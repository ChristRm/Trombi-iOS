//
//  UIColor+Convenience.swift
//  Trombi
//
//  Created by Chris Rusin on 12/22/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: CGFloat) {
        self.init(red: CGFloat(redInt)/255.0,
                  green: CGFloat(greenInt)/255.0,
                  blue: CGFloat(blueInt)/255.0,
                  alpha: alpha)
    }

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0x00ff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x0000ff00) >> 8) / 255.0
        let blue = CGFloat((hex & 0x000000ff)) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
