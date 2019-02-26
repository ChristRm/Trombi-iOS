//
//  TagCellLayoutDelegate.swift
//  TagCellLayout
//
//  Created by Ritesh Gupta on 06/01/18.
//  Copyright © 2018 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public protocol TagCellLayoutDelegate: NSObjectProtocol {
	
	func tagCellLayoutTagSize(layout: TagCellLayout, at indexPath: IndexPath) -> CGSize

    func tagCellLayout(layout: TagCellLayout, heightForHeaderAt indexPath: IndexPath) -> CGFloat
    
    func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat
    func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat
}
