import UIKit
import Firebase

class MainTabController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        checkIfUserIsLoggedIn()
    }

    // MARK: - API

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Helpers

    func configureViewControllers() {
        view.backgroundColor = .white
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(
            unselectedImage: UIImage(named: "home_unselected")!,
            selectedImage: UIImage(named: "home_selected")!,
            rootViewController: FeedController(collectionViewLayout: layout))

        let search = templateNavigationController(
            unselectedImage: UIImage(named: "search_unselected")!,
            selectedImage: UIImage(named: "search_selected")!,
            rootViewController: SearchController())

        let imageSelector = templateNavigationController(
            unselectedImage: UIImage(named: "plus_unselected")!,
            selectedImage: UIImage(named: "plus_unselected")!,
            rootViewController: ImageSelectorController())

        let notifications = templateNavigationController(
            unselectedImage: UIImage(named: "like_unselected")!,
            selectedImage: UIImage(named: "like_selected")!,
            rootViewController: NotificationsController())

        let profile = templateNavigationController(
            unselectedImage: UIImage(named: "profile_unselected")!,
            selectedImage: UIImage(named: "profile_selected")!,
            rootViewController: ProfileController())

        viewControllers = [feed, search, imageSelector, notifications, profile]
        tabBar.tintColor = .black

    }

    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {

        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        return nav
    }

}
