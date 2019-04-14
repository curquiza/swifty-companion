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
    
    var user: User?
    
    override func viewDidLoad() {
        print("[Profile view loaded]")
        
        print("user = \(user)")
        
        title = "Profile"
    }
}

