import UIKit

class SettingViewController: UITableViewController {
    var contentsList: [[ContentModel]]
    var categoryNames: [String]
    
    init(contentsList: [[ContentModel]]) {
        self.contentsList = contentsList
        self.categoryNames = contentsList.map({section in
            return section[0].category
        })
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "表示設定"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(_:)))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
    }
    
    @objc func didTapSaveButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didTapCancelButton(_ sender: UIBarButtonItem) {
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailSettingVC = DetailSettingViewController(contents: contentsList[indexPath.row])
        self.navigationController?.pushViewController(detailSettingVC, animated: true)
    }
}
