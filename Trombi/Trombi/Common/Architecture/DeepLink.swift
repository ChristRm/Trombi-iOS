//
//  DeepLink.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import Foundation

public protocol DeepLinkBase {}

protocol DeepLinkOptionProcessCapable {
    func handle(deepLink: DeepLinkBase)
}
