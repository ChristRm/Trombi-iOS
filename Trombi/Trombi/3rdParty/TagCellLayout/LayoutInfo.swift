//
//  LayoutInfo.swift
//  TagCellLayout
//
//  Created by Ritesh Gupta on 06/01/18.
//  Copyright © 2018 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public extension TagCellLayout {
	
	struct LayoutInfo {

        var indexPath: IndexPath

		var layoutAttribute: UICollectionViewLayoutAttributes
		var whiteSpace: CGFloat = 0.0
        
        var isFirstElementInLayoutRow: Bool
		
        init(indexPath: IndexPath, layoutAttribute: UICollectionViewLayoutAttributes, isFirstElementInLayoutRow: Bool) {
            self.indexPath = indexPath
			self.layoutAttribute = layoutAttribute
            self.isFirstElementInLayoutRow = isFirstElementInLayoutRow
		}
	}
}
