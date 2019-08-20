import Foundation

public struct FibonacciSequence: Sequence {

    private(set) var limit: Int
    public init(limit: Int) {
        self.limit = limit
    }

    public func makeIterator() -> FibonacciNumbersIterator {
        return FibonacciNumbersIterator(limit: limit)
    }
}

public struct FibonacciNumbersIterator: IteratorProtocol {
    private var previousValue: Int = 0
    private var currentValue: Int = 1
    private var index: Int = 0
    private var limit: Int

    init(limit: Int) {
        self.limit = limit
    }

    var description: String {
        return "previousValue: \(previousValue) \n currentValue: \(currentValue) \n index: \(index) limit: \(limit)"
    }

    public mutating func next() -> Int? {
        guard index >= 0, index < limit else { return nil }

        let newValue = previousValue + currentValue
        previousValue = currentValue
        currentValue = newValue

        index += 1

        return newValue
    }
}
