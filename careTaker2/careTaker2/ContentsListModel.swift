
enum ContentsListModelState {
    case loading
    case finish
    case error(Error)
}

class ContentsListModel {
    var stateDidUpdate: ((ContentsListModelState) -> Void)?
    var Contents = [ContentModel]()
    let api = API()
    
    func pullContents() {
        
    }
    
}
