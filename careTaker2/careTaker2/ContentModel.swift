import UIKit

class ContentModel: Codable {
    var name: String
    var category: String
    var interval: Int
    var lastDate: String
    
    init(name:String, category:String, interval:Int, lastDate:String){
        self.name = name
        self.category = category
        self.interval = interval
        self.lastDate = lastDate
    }
}
