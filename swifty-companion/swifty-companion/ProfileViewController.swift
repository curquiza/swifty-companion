//
//  ProfileViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/14/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit
import p2_OAuth2

class ProfileViewController: UIViewController {
    
    var oauth2: OAuth2ClientCredentials?
    var api42Controller: APIController?

    var user: User?
    
    override func viewDidLoad() {
        print("[Profile view loaded]")
        
        api42Controller = APIController(oauth2: self.oauth2, delegate: self)
        api42Controller?.performUserRequest()
    }
}

extension ProfileViewController: API42Delegate {
    
    func fetchUser(userResult: User) {
        self.user = userResult
    }
}

protocol API42Delegate {
    func fetchUser(userResult: User)
}
