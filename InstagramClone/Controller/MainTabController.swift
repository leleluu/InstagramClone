import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {

    // MARK: - Lifecycle

    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
    }

    // MARK: - API

    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Helpers

    func configureViewControllers(withUser user: User) {
        self.delegate = self
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

        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(
            unselectedImage: UIImage(named: "profile_unselected")!,
            selectedImage: UIImage(named: "profile_selected")!,
            rootViewController: profileController)

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

    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }

}

extension MainTabController: AuthenticatonDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)

        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1

            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)

            didFinishPickingMedia(picker)
        }
        return true
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)

        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }

        feed.handleRefresh()
    }


}
