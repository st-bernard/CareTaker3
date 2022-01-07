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
        title = "表示項目選択"
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
        if contents[indexPath.row].isActive == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let updater = FirebaseContentRepository.Updater(section: contents[indexPath.row].section, row: contents[indexPath.row].row)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            updater.updateIsActive(isActive: false)
            contents[indexPath.row] = ContentModel(
                name: contents[indexPath.row].name,
                category: contents[indexPath.row].category,
                interval: contents[indexPath.row].interval,
                lastDate: contents[indexPath.row].lastDate,
                section: contents[indexPath.row].section,
                row: contents[indexPath.row].row,
                isActive: false
            )
        } else {
            cell?.accessoryType = .checkmark
            updater.updateIsActive(isActive: true)
            contents[indexPath.row] = ContentModel(
                name: contents[indexPath.row].name,
                category: contents[indexPath.row].category,
                interval: contents[indexPath.row].interval,
                lastDate: contents[indexPath.row].lastDate,
                section: contents[indexPath.row].section,
                row: contents[indexPath.row].row,
                isActive: true
            )
        }
    }
}
