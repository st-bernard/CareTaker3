
class ContentModel: Codable {
    var name: String
    var category: String
    var interval: Int
    var lastDate: String
    var section: Int
    var row: Int
    var isActive: Bool
    
    init(nameofTASU:String,categoryofTASU:String,intervalofTASU:Int,LastDateofTASU:String,sectionofTASU:Int,rowofTASU:Int,isActiveofTASU:Bool){
        name = nameofTASU
        category = categoryofTASU
        interval = intervalofTASU
        lastDate = LastDateofTASU
        section = sectionofTASU
        row = rowofTASU
        isActive = isActiveofTASU
    }
}
