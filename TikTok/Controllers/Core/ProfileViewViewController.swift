//
//  ProfileViewViewController.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 31/03/22.
//

import UIKit

class ProfileViewViewController: UIViewController {

    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground

    }

}
