
struct ContentModel: Codable {
    var name: String
    var category: String
    var interval: Int
    var lastDate: String
    var section: Int
    var row: Int
    var isActive: Bool
    var isHome: Bool?
    var locationLon: Double?
    var locationLat: Double?
    var locationName: String?
}
