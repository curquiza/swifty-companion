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
    
    let mainTextColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    let invisibleFontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let basicInfoFontSize: CGFloat = 12.0
    
    let cursus42Id = 1
    let cursusPoleEmploiId = 10
    let cursusPiscineCDecloisonneeId = 6
    let cursusPiscineCCloisonneeId = 4

    var currentCursusId: Int?
    var user: User?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var correctionPointLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cursusStatusLabel: UILabel!
    @IBOutlet weak var cursusNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        print("[Profile view loaded]")
        title = "Profile"
        
        /* Bakcground */
        guard let image = UIImage(named: "42_background") else { return }
        self.view.backgroundColor = UIColor(patternImage: image)
        
        /* Photo */
        profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.image = stringURLToUIImage(stringURL: user?.image_url)
        
        /* Basic infos */
        fillBasicInfo()
        
        /* Pick cursus id */
        if let c = user?.cursus_users.first(where: { $0.cursus_id == cursus42Id }) {
            self.currentCursusId = c.cursus_id
        } else if let c = user?.cursus_users.first(where: { $0.cursus_id == cursusPoleEmploiId }) {
            self.currentCursusId = c.cursus_id
        } else if let c = user?.cursus_users.first(where: { $0.cursus_id == cursusPiscineCCloisonneeId }) {
            self.currentCursusId = c.cursus_id
        } else if let c = user?.cursus_users.first(where: { $0.cursus_id == cursusPiscineCDecloisonneeId }){
            self.currentCursusId = c.cursus_id
        }
        
        /* Cursus infos */
        cursusStatusLabel.font = cursusStatusLabel.font.withSize(20)
        cursusStatusLabel.text = "Cursus unavailable"
        cursusStatusLabel.textColor = invisibleFontColor
        if let cursusId = currentCursusId {
            if let cursus = user?.cursus_users.first(where: { $0.cursus_id == cursusId }) {
                let g = cursus.grade ?? "Novice"
                let l = cursus.level ?? 0.0
                cursusStatusLabel.text = "level : \(l) - \(g)"
                cursusStatusLabel.textColor = mainTextColor
                
                cursusNameLabel.text = "Cursus unavailable"
                cursusNameLabel.textColor = invisibleFontColor
                if let name = cursus.cursus?.name {
                    cursusNameLabel.text = "Cursus \(name)"
                    cursusNameLabel.textColor = mainTextColor
                }
            }
        }

        /* Skills */
        
        /* Projects */
    }
    
    func stringURLToUIImage(stringURL: String?) -> UIImage? {
        guard let str = stringURL else { return nil }
        guard let imageURL = URL(string: str) else {return nil}
        if let imageData: NSData = NSData(contentsOf: imageURL) {
            return UIImage(data: imageData as Data)
        }
        return nil
    }
    
    func fillBasicInfo() {
        if let login = user?.login {
            loginLabel.text = login
            loginLabel.textColor = mainTextColor
            loginLabel.font = UIFont.boldSystemFont(ofSize: 25)
        }
        if let firstName = user?.first_name {
            if let lastName = user?.last_name {
                nameLabel.text = "\(firstName) \(lastName)"
                nameLabel.textColor = mainTextColor
                nameLabel.font = nameLabel.font.withSize(basicInfoFontSize)
            }
        }
        if let email = user?.email {
            emailLabel.text = email
            emailLabel.textColor = mainTextColor
            emailLabel.font = emailLabel.font.withSize(basicInfoFontSize)
        }
        if let correctionPoint = user?.correction_point {
            correctionPointLabel.text = "correction points : \(correctionPoint)"
            correctionPointLabel.textColor = mainTextColor
            correctionPointLabel.font = correctionPointLabel.font.withSize(basicInfoFontSize)
        }
        if let wallet = user?.wallet {
            walletLabel.text = "wallet : \(wallet)"
            walletLabel.textColor = mainTextColor
            walletLabel.font = walletLabel.font.withSize(basicInfoFontSize)
        }
        if let location = user?.location {
            locationLabel.text = location
            locationLabel.textColor = mainTextColor
        } else {
            locationLabel.text = "location unavailable"
            locationLabel.font = locationLabel.font.withSize(12)
            locationLabel.textColor = invisibleFontColor
        }
    }
}

