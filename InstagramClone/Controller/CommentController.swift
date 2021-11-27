import UIKit

class CommentController: UICollectionViewController {
    // MARK: - Properties

    private let reuseIdentifier = "CommentCell"

    private let post: Post
    private var comments = [Comment]()

    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()

    // MARK: - Lifecycle

    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }

    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - API

    func fetchComments() {
        CommentService.fetchComments(postID: post.postId) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }


    // MARK: - Helper
    
    func configureCollectionView() {
        navigationItem.title = "Comments"

        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}


// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComments comment: String) {

        guard let tab = tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }

        showLoader(true)
        CommentService.uploadComment(comment: comment, postID: post.postId, user: user) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()

        }
    }


}
