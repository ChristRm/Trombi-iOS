//
//  UIView+FindFirstTextField.swift
//  Trombi
//
//  Created by Chris Rusin on 1/11/20.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit

extension UIView {
    func findFirstTextField() -> UITextField? {
        if self is UITextField {
            return self as? UITextField
        }

        for subView in subviews {
            let textField = subView.findFirstTextField()
            if textField != nil {
                return textField
            }
        }

        return nil
    }
}
