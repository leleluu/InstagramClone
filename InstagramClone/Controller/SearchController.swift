import UIKit

class SearchController: UITableViewController{

    private let reuseIdentifier = "UserCell"

    // MARK: - Properties
    private var users = [User]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchUsers()
    }

    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }

    // MARK: - API

    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }

}

// MARK: - UITableviewDataSource

extension SearchController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.viewModel = UserCellViewModel(user: users[indexPath.row])
        return cell
    }
}
