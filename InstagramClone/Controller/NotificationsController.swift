import UIKit

class NotificationsController: UITableViewController {

    // MARK: - Properties

    private let reuseIdentifier = "NotificationCell"
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }

    // MARK: - API

    func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
        }
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifcations"

        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

}


// MARK: -

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        return cell
    }
}
