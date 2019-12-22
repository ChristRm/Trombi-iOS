//
//  Stack.swift
//  Trombi
//
//  Created by Chris Rusin on 12/22/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation

struct Queue<Element: Equatable> {
    private(set) var queueArray: [Element] = []
    let maximumSize: Int

    init(maximumSize: Int) {
        self.maximumSize = maximumSize
    }

    init(maximumSize: Int, incomingOrder: [Element]) {
        self.maximumSize = maximumSize
        queueArray = Array(incomingOrder.prefix(maximumSize))
    }

    mutating func push(_ element: Element) {
        guard !queueArray.contains(element) else { return }

        if queueArray.count >= maximumSize {
            pop()
        }

        queueArray.insert(element, at: 0)
    }

    @discardableResult public mutating func pop() -> Element? {
        return queueArray.popLast()
    }
}
