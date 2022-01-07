import Foundation

struct ContentModel: Codable {
    var id: String?
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
    
    func getNextDue(hour: Int = 17, minute: Int = 45, second: Int = 0) -> Date? {
        let last = DateUtils.dateFromString(string: lastDate + " 00:00:00 +09:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
        var nextDueDate = Calendar.current.date(byAdding: .day, value: interval, to: last)
        nextDueDate = Calendar.current.date(byAdding: .hour, value: hour, to: nextDueDate!)
        nextDueDate = Calendar.current.date(byAdding: .minute, value: minute, to: nextDueDate!)
        nextDueDate = Calendar.current.date(byAdding: .second, value: second, to: nextDueDate!)
        return nextDueDate
    }
}
