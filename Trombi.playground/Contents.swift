import Foundation

enum RunMode {
    case jsonsParsing
    case sequenceExample
    case queueExample
}

let runMode: RunMode = .queueExample

if runMode == .jsonsParsing {
    guard let personsapiUrl = Bundle.main.url(forResource: "personsapi", withExtension: "json") else {
        fatalError()
    }

    guard let linksapiUrl = Bundle.main.url(forResource: "linksapi", withExtension: "json") else {
        fatalError()
    }

    guard let teamsapiUrl = Bundle.main.url(forResource: "teamsapi", withExtension: "json") else {
        fatalError()
    }

    guard let personsData = try? Data(contentsOf: personsapiUrl) else {
        fatalError()
    }

    guard let linksData = try? Data(contentsOf: linksapiUrl) else {
        fatalError()
    }

    guard let teamsData = try? Data(contentsOf: teamsapiUrl) else {
        fatalError()
    }

    let decoder = JSONDecoder()

    do {
        let personsResponse = try decoder.decode(Array<Employee>.self, from: personsData)

        let linksResponse = try decoder.decode(Array<UsefulLink>.self, from: linksData)

        let teamsResponse = try decoder.decode(Array<Team>.self, from:teamsData)

        print("==================Persons==================")
        personsResponse.forEach { print($0) }

        print("==================Links==================")
        linksResponse.forEach { print($0) }

        print("==================Teams==================")
        teamsResponse.forEach { print($0) }
    } catch {
        print(error)
    }
} else if runMode == .sequenceExample {
    let fibonacciSequence = FibonacciSequence(limit: 10)

    fibonacciSequence.forEach { print($0) }
} else if runMode == .queueExample {
    var queue = Queue<String>(maximumSize: 3)

    queue.push("A")
    queue.push("B")
    queue.push("C")
    queue.push("D")

    print(queue)

    queue.pop()

    print(queue)

    let queue2 = Queue<String>(maximumSize: 3, incomingOrder: ["A", "B", "C", "D", "E"])

    print(queue2)
}
