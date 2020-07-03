//
//  UICollectionView+dequeueReusableCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/22/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerReusableCell<T: UICollectionViewCell>(type: T.Type) {
        register(UINib(nibName: T.staticReuseIdentifier, bundle: nil),
                 forCellWithReuseIdentifier: T.staticReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.staticReuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }

        return cell
    }

    func registerReusableHeader<T: UICollectionReusableView>(type: T.Type) {
        register(
            UINib(nibName: T.staticReuseIdentifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.staticReuseIdentifier
        )
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let reusableHeader = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.staticReuseIdentifier,
            for: indexPath
            ) as? T else {
                fatalError("Unable to Dequeue Reusable Table View Header")
        }

        return reusableHeader
    }
}
