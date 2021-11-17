import UIKit

class LoginController: UIViewController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .systemPink
        navigationController?.navigationBar.isHidden = true


    }
}
