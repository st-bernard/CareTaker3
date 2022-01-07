import Foundation

class DateUtils {
    
    class func makeString(_ date: DateComponents) -> String {
        return "\(date.year ?? 0)/\(date.month ?? 0)/\(date.day ?? 0) \(date.hour ?? 0):\(String(format: "%02d", date.minute ?? 0)):\(String(format: "%02d", date.second ?? 0))"
    }
    
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    enum DateTimeParts: String {
        case year4 = "y"
        case month = "M"
        case day = "d"
        case hour24 = "H"
        case minute = "m"
        case second = "s"
    }
    
    // y/M/d H:m:s
    class func getDateTimePart(_ date: Date, part: DateTimeParts) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = part.rawValue
        let partString = dateFormatter.string(from: date)
        return Int(partString)!
    }
}
