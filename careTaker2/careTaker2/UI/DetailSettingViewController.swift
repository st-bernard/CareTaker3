import UIKit

class DetailSettingViewController: UITableViewController {
    var contents: [ContentModel]
    var contentNames: [String]
    
    init(contents: [ContentModel]) {
        self.contents = contents
        self.contentNames = contents.map({content in
            return content.name
        })
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "詳細表示設定"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailTableCell")
    }
}

extension DetailSettingViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailTableCell", for: indexPath)
        cell.textLabel?.text = contentNames[indexPath.row]
        
        return cell
    }
}
