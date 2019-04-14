//
//  ViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/7/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit
import p2_OAuth2

class LoginViewController: UIViewController, UITextFieldDelegate {

    var oauth2: OAuth2ClientCredentials?
    var api42Controller: APIController?
    
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.delegate = self
        }
    }
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Login view loaded]")
        initUI()
        getToken()
        api42Controller = APIController(oauth2: self.oauth2, delegate: self)
    }
    
    /*** Move to Profile View ***/
    @IBAction func searchButtonAction(_ sender: UIButton) {
        print("[Search button pressed]")
        performRequest()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("[Enter pressed]")
        performRequest()
        return true
    }
    
    func performRequest() {
        guard let login = loginTextField.text else { return }
        if (login != "") {
            print("Login text field : \(login)")
            self.api42Controller?.getUserRequest(login: login)
        }
    }
    
    /*** Alert ***/
    func launchAlert(str: String) {
        let alert = UIAlertController(title: "An error occured", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("Alert : \(str)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*** Token ***/
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

        guard let t = oauth2?.accessToken else { return }
        print("Token got = \(t)")
    }
    
    /*** UI ***/
    func initUI() {
        title = "Search"
        
        let mainColor = UIColor(red: 0.0, green: 186/255.0, blue: 188/255.0, alpha: 1.0)
        
        loginTextField.layer.borderColor = mainColor.cgColor
        loginTextField.layer.borderWidth = 2.0
        loginTextField.layer.cornerRadius = 5.0
        loginTextField.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        loginTextField.tintColor = .white
        loginTextField.textColor = .white
        loginTextField.font = UIFont.boldSystemFont(ofSize: 14)
        
        searchButton.setTitle("SEARCH", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        searchButton.layer.cornerRadius = 5.0
        searchButton.backgroundColor = mainColor
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        guard let image = UIImage(named: "42_background") else { return }
        self.view.backgroundColor = UIColor(patternImage: image)
    }
}


extension LoginViewController: API42Delegate {
    
    func fetchUser(userResult: User) {
        let nextvView = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        nextvView.user = userResult
        self.navigationController?.pushViewController(nextvView, animated: true)
    }
    
    func noUserError() {
        launchAlert(str: "This login does not exist")
    }
    
    func badRequestError(error: Error) {
        launchAlert(str: error.localizedDescription)
    }
}

protocol API42Delegate {
    func fetchUser(userResult: User)
    func noUserError()
    func badRequestError(error: Error)
}
