//
//  ViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/7/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit
import p2_OAuth2

class LoginViewController: UIViewController {

    var oauth2: OAuth2ClientCredentials?
    var api42Controller: APIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getToken()
        api42Controller = APIController(oauth2: self.oauth2, delegate: self)
        api42Controller?.performUserRequest()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        print("USER:")
        print(user)
    }
    
    func launchAlert(str: String) {
        let alert = UIAlertController(title: "An error occured", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("Alert : \(str)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getToken() {
        guard let uid = ProcessInfo.processInfo.environment["42_UID"] else { return }
        guard let secret = ProcessInfo.processInfo.environment["42_SECRET"] else { return }
        
        oauth2 = OAuth2ClientCredentials(settings: [
            "client_id": uid,
            "client_secret": secret,
            "token_uri": "https://api.intra.42.fr/oauth/token",
        ])
        
        oauth2?.authorize(callback: { (response, error) in
            if let e = error {
                print("Error: \(e)")
                DispatchQueue.main.async {
                    self.launchAlert(str: "Impossible to get 42 API Token")
                }
            }
        })
        
        // Print token in log
        guard let t = oauth2?.accessToken else { return }
        print("Token got = \(t)")
    }
    
    // test user
    var user: User?
}

extension LoginViewController: API42Delegate {
    
    func fetchUser(userResult: User) {
        self.user = userResult
    }
}

protocol API42Delegate {
    func fetchUser(userResult: User)
}
