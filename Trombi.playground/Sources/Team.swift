import Foundation

public struct Team: Codable {

    enum CodingKeys: String, CodingKey {

        case identifier = "id"
        case name = "name"
        case members = "persons"

        case higherTeamlId = "higher_teaml_id"
    }

    public var identifier: Int64
    public var name: String

    public var members: [String]

    public var higherTeamlId: Int64?
}
