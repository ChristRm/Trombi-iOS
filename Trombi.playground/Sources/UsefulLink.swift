import Foundation

public struct UsefulLink: Codable {

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case url = "url"

        case title = "title"
        case description = "description"
        case imageUrl = "image_url"
    }

    public var identifier: Int64

    public var url: String
    public var title: String
    public var description: String

    public var imageUrl: String
}
