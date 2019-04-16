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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        print("[Profile view loaded]")
        title = "Profile"
        
        profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.image = stringURLToUIImage(stringURL: user?.image_url)
        
        guard let image = UIImage(named: "42_background") else { return }
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func stringURLToUIImage(stringURL: String?) -> UIImage? {
        guard let str = stringURL else { return nil }
        guard let imageURL = URL(string: str) else {return nil}
        if let imageData: NSData = NSData(contentsOf: imageURL) {
            return UIImage(data: imageData as Data)
        }
        return nil
    }
    

}

