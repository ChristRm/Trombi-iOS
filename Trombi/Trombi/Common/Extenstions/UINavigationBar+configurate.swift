//
//  UINavigationBar+configurate.swift
//  Trombi
//
//  Created by Christian Rusin on 19/04/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit

extension UINavigationBar {
    func configurate() {
        // in iOS 13 each navigation bar has to be configurated indendently
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            
            navigationBarAppearance.backgroundColor = UIColor.mainWhiteColor
            navigationBarAppearance.titleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor.mainBlackColor,
                 NSAttributedString.Key.font: UIFont.semiBoldAppFontOf(size: 17)]
            navigationBarAppearance.shadowColor = .clear
            
            navigationBarAppearance.largeTitleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor.mainBlackColor,
                 NSAttributedString.Key.font: UIFont.semiBoldAppFontOf(size: 28)]
            
            standardAppearance = navigationBarAppearance
            compactAppearance = navigationBarAppearance
            scrollEdgeAppearance = navigationBarAppearance
        }
    }
}
