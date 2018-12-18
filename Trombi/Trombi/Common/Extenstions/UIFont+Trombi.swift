//
//  UIFont+Trombi.swift
//  Trombi
//
//  Created by Chris Rusin on 12/25/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

extension UIFont {

    class public func boldAppFontOf(size fontSize: CGFloat) -> UIFont {
        return loadFont(name: "Muli-Bold", size: fontSize)
    }

    class public func semiBoldAppFontOf(size fontSize: CGFloat) -> UIFont {
        return loadFont(name: "Muli-SemiBold", size: fontSize)
    }

    class public func extraBoldAppFontOf(size fontSize: CGFloat) -> UIFont {
        return loadFont(name: "Muli-ExtraBold", size: fontSize)
    }

    class private func loadFont(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        } else {
            fatalError("Failed to load app font")
        }
    }
}
