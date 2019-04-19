//
//  ViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/7/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

// TESTS:
// - mthomas : piscine C decloisonnée
// - xbarthe : pole emploi
// - 3b3-20 : anonymisé
// - norminet
// - supervisor
// - thor

import UIKit
import p2_OAuth2

class LoginViewController: UIViewController {

    var oauth2: OAuth2ClientCredentials?
    var api42Controller: APIController?
    
    @IBOutlet weak var loginTextField: UITextField!
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
    
    func performRequest() {
        guard let login = loginTextField.text else { return }
        if (login != "") {
            print("Login text field : \(login)")
            searchButton.isEnabled = false
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
        searchButton.isEnabled = true
    }
    
    /*** Token ***/
    func getToken() {
        guard let uid = ProcessInfo.processInfo.environment["42_UID"] else { tokenAlert(); return }
        guard let secret = ProcessInfo.processInfo.environment["42_SECRET"] else { tokenAlert(); return }
        
        oauth2 = OAuth2ClientCredentials(settings: [
            "client_id": uid,
            "client_secret": secret,
            "token_uri": "https://api.intra.42.fr/oauth/token",
        ])
        
        oauth2?.authorize(callback: { (response, error) in
            if let e = error {
                print("Error: \(e)")
                DispatchQueue.main.async {
                    self.tokenAlert()
                }
            }
        })

        guard let t = oauth2?.accessToken else { return }
        print("Token got = \(t)")
    }
    
    func tokenAlert() {
        self.launchAlert(str: "Impossible to get 42 API Token")
        searchButton.isEnabled = false
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
        
        if let image = UIImage(named: "42_background") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }
}

extension LoginViewController {

    func getCursusId(user: User) -> Int? {
        let cursus42Id = 1
        let cursusPoleEmploiId = 10
        let cursusPiscineCDecloisonneeId = 6
        let cursusPiscineCCloisonneeId = 4
        
        if let c = user.cursus_users.first(where: { $0.cursus_id == cursus42Id }) {
            return c.cursus_id
        } else if let c = user.cursus_users.first(where: { $0.cursus_id == cursusPoleEmploiId }) {
            return c.cursus_id
        } else if let c = user.cursus_users.first(where: { $0.cursus_id == cursusPiscineCCloisonneeId }) {
            return c.cursus_id
        } else if let c = user.cursus_users.first(where: { $0.cursus_id == cursusPiscineCDecloisonneeId }){
            return c.cursus_id
        }
        return nil
    }
    
    func projectIsInCursus(currentCursusId: Int?, cursusIdsTab: [Int]) -> Bool {
        if let c = currentCursusId {
            return cursusIdsTab.contains(c)
        }
        return false
    }
    
    func setTabBar(userResult: User) -> UITabBarController {
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        let skillsView = self.storyboard?.instantiateViewController(withIdentifier: "skillsViewController") as! SkillsViewController
        let projectsView = self.storyboard?.instantiateViewController(withIdentifier: "projectsViewController") as! ProjectsViewController
        profileView.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 1)
        skillsView.tabBarItem = UITabBarItem(title: "Skills", image: UIImage(named: "skills"), tag: 1)
        projectsView.tabBarItem = UITabBarItem(title: "Projects", image: UIImage(named: "projects"), tag: 1)
        let currentCursusId = getCursusId(user: userResult)
        profileView.user = userResult
        profileView.currentCursusId = currentCursusId
        if let cursus = userResult.cursus_users.first(where: { $0.cursus_id == currentCursusId }) {
            skillsView.skills = cursus.skills
        }
        projectsView.projectsUser = userResult.projects_users.filter({ projectIsInCursus(currentCursusId: currentCursusId, cursusIdsTab: $0.cursus_ids) })
        let tabBar = UITabBarController()
        tabBar.setViewControllers([profileView, skillsView, projectsView], animated: true)
        return tabBar
    }
}

extension LoginViewController: API42Delegate {
    
    func fetchUser(userResult: User) {
        let tabBar = setTabBar(userResult: userResult)
        searchButton.isEnabled = true
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
    func noUserError() {
        launchAlert(str: "Impossible to get this user")
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
