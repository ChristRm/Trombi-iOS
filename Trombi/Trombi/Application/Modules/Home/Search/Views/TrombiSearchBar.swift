//
//  TrombiSearchBar.swift
//  Trombi
//
//  Created by Chris Rusin on 9/28/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

protocol TrombiSearchBarDelegate: class {
    func dismissTapped()
}

class TrombiSearchBar: UISearchBar {

    weak var trombiDelegate: TrombiSearchBarDelegate?

    private let preferredFont: UIFont! = UIFont.semiBoldAppFontOf(size: 22.0)
    private let preferredTextColor: UIColor! = UIColor.gray

    private let backButton: UIButton = UIButton(frame: .zero)

    private var searchFieldContainer: UIView {
        return subviews[0]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        searchFieldContainer.backgroundColor = UIColor.mainWhiteColor
        barTintColor = UIColor.mainWhiteColor
        showsBookmarkButton = false
        showsCancelButton = false
        setImage(UIImage(named: "icBack"), for: .search, state: .normal)// TODO: this image is wrong
        setPositionAdjustment(UIOffset(horizontal: 5.0, vertical: 0.0), for: .search)
        searchTextPositionAdjustment = UIOffset(horizontal: 5.0, vertical: 0.0)

        searchBarStyle = UISearchBar.Style.prominent

        backButton.backgroundColor = .clear
        backButton.setTitle(nil, for: .normal)
        backButton.setImage(UIImage(named: "icDone"), for: .normal)

        backButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        searchFieldContainer.addSubview(backButton)

        layer.borderWidth = 1.0
        layer.borderColor = UIColor.mainWhiteColor.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }

    override func draw(_ rect: CGRect) {

        guard let index = indexOfSearchFieldInSubviews() else { return }
        // Access the search field
        guard let majorSearchField: UITextField =
            searchFieldContainer.subviews[index] as? UITextField else { return }

        majorSearchField.subviews.forEach { subview in

            if let imageView = subview as? UIImageView {
                imageView.frame.size = CGSize(width: 22.0, height: 22.0)

                let originShit = majorSearchField.convert(imageView.frame.origin, to: self)

                backButton.frame.size = CGSize(width: originShit.x + imageView.frame.width, height: frame.height)
                backButton.frame.origin = .zero
                searchFieldContainer.bringSubviewToFront(backButton)
            }
        }

        // Set its frame.
        majorSearchField.frame =
            CGRect(
                x: 5.0,
                y: 5.0,
                width: frame.size.width - 10.0,
                height: frame.size.height - 10.0
        )

        // Set the font and text color of the search field.
        majorSearchField.font = preferredFont
        majorSearchField.textColor = preferredTextColor

        // Set the background color of the search field.
        majorSearchField.backgroundColor = barTintColor

        let startPoint = CGPoint(
            x: 0.0,
            y: frame.size.height
        )
        let endPoint = CGPoint(
            x: frame.size.width,
            y: frame.size.height
        )
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = preferredTextColor.cgColor
        shapeLayer.lineWidth = 1.0

        layer.addSublayer(shapeLayer)
    }

    private func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!

        for i in 0...searchFieldContainer.subviews.count {
            if let _ = searchFieldContainer.subviews[i] as? UITextField {
                index = i
                break
            }
        }

        return index
    }

    @objc private func imageTapped() {
        trombiDelegate?.dismissTapped()
    }
}
