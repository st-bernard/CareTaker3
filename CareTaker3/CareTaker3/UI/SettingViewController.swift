import UIKit

class SettingViewController: UITableViewController {
    var contentsList = Dictionary<Int, Array<ContentModel>>()
    var activeModelSortedKeys = Array<Int>()
    var categoryNames = [String]()
    
//    init(contentsList: [[ContentModel]], delegate: ReceiverDelegate) {
//        self.contentsList = contentsList
//        self.delegate = delegate
//        self.categoryNames = contentsList.map({section in
//            return section[0].category
//        })
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeModelSortedKeys = contentsList.keys.map{ Int($0) }
        activeModelSortedKeys.sort()
        
        title = "Your Choice"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapDoneButton(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
    }
    
    @objc func didTapDoneButton(_ sender: UIBarButtonItem) {
        // delegate?.reloadView() 子供から親Viewのメソッドを読んで更新を期待した処理
        dismiss(animated: true)
    }
    
}

extension SettingViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = categoryNames[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryName = categoryNames[indexPath.row]
        let contents = contentsList.values.flatMap{ $0 }.filter{ $0.category == categoryName }
        let detailSettingVC = DetailSettingViewController(contents: contents)
        self.navigationController?.pushViewController(detailSettingVC, animated: true)
    }
}
