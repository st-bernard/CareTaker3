import UIKit

class ContentModel: Codable {
    var name: String
    var category: String
    var iconImage: String
    var interval: String
    var lastDate: String
    
    init(name:String, category:String, iconImage:String, interval:String, lastDate:String){
        self.name = name
        self.category = category
        self.iconImage = iconImage
        self.interval = interval
        self.lastDate = lastDate
    }
}
