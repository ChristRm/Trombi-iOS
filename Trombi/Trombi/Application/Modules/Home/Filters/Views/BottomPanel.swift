//
//  BottomPanel.swift
//  Trombi
//
//  Created by Christian Rusin on 06/05/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit

protocol BottomPanel {
    var panelIdentifier: String? { get set }
    
    var widthOfPanel: CGFloat { get set }
    var heightOfPanel: CGFloat { get }
    
    var bottomPanelDelegate: BottomPanelDelegate? { get set }
}

protocol BottomPanelDelegate: class {
    func bottomPanel(_ dashboardBottomPanel: BottomPanel, willChange height: CGFloat, animated: Bool)
}
