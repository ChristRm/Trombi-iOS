import Foundation

public struct Queue<Element> {
    private(set) var queueArray: [Element] = []
    let maximumSize: Int

    public init(maximumSize: Int) {
        self.maximumSize = maximumSize
    }

    public init(maximumSize: Int, incomingOrder: [Element]) {
        self.maximumSize = maximumSize
        queueArray = Array(incomingOrder.prefix(maximumSize))
    }

    public mutating func push(_ element: Element) {
        if queueArray.count >= maximumSize {
            pop()
        }

        queueArray.insert(element, at: 0)
    }

    @discardableResult public mutating func pop() -> Element? {
        return queueArray.popLast()
    }
}
