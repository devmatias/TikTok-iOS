//
//  CommentViewController.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 03/04/22.
//

import UIKit

class CommentsViewController: UIViewController {

    private let post: PostModel
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchPostComments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func fetchPostComments() {
        
    }
    
    
}
