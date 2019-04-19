//
//  ProfileViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/14/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    
    let mainTextColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

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
    @IBOutlet weak var basicInfoStackView: UIStackView!
    @IBOutlet weak var cursusInfoStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Profile view loaded]")

        /* Background */
        if let image = UIImage(named: "42_background") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }

        /* Photo */
        profileImageView.contentMode = .scaleAspectFit
        if let i = stringURLToUIImage(stringURL: user?.image_url) {
            self.profileImageView.image = i
        } else {
            self.profileImageView.image = UIImage(named: "droide")
        }
        
        /* Main infos */
        fillMainInfo()
        
        /* Basic infos */
        fillBasicInfo()
        
        /* Cursus infos */
        fillCursusInfo()
    }
    
    func stringURLToUIImage(stringURL: String?) -> UIImage? {
        guard let str = stringURL else { return nil }
        guard let imageURL = URL(string: str) else {return nil}
        if let imageData: NSData = NSData(contentsOf: imageURL) {
            return UIImage(data: imageData as Data)
        }
        return nil
    }
    
    func locationWithDotImage(location: String, color: UIColor) {
        locationLabel.textColor = mainTextColor
        locationLabel.textAlignment = .center
        
        if let image = UIImage(named: "dot", in: Bundle.main, compatibleWith: nil) {
            let templateImage = image.withRenderingMode(.alwaysTemplate)

            let textAttachment = NSTextAttachment()
            textAttachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
            textAttachment.image = templateImage
            let attributedStringWithImage = NSAttributedString(attachment: textAttachment);
            
            let stringToDisplay = "\(location) "

            let fullAttributedString = NSMutableAttributedString(string:"\(stringToDisplay) ")
            fullAttributedString.append(attributedStringWithImage)
            fullAttributedString.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: color,
                range: NSMakeRange(
                    stringToDisplay.count, attributedStringWithImage.length))
            
            locationLabel.attributedText = fullAttributedString
        }
    }
    
    func fillMainInfo() {
        if let login = user?.login {
            loginLabel.text = login
            loginLabel.textAlignment = NSTextAlignment.center
            loginLabel.textColor = mainTextColor
            loginLabel.font = UIFont.boldSystemFont(ofSize: 25)
        }
        locationLabel.textAlignment = NSTextAlignment.center
        if let location = user?.location {
            locationWithDotImage(location: location, color: .green)
        } else {
            locationWithDotImage(location: "unavailable", color: .red)
        }
    }
    
    func fillBasicInfo() {
        basicInfoStackView.addBackground(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.75))
        basicInfoStackView.layoutMargins = UIEdgeInsetsMake(20, 10, 20, 10)
        basicInfoStackView.isLayoutMarginsRelativeArrangement = true
        if let firstName = user?.first_name {
            if let lastName = user?.last_name {
                nameLabel.text = "\(firstName) \(lastName)"
                nameLabel.textColor = mainTextColor
                nameLabel.textAlignment = NSTextAlignment.center
            }
        }
        if let email = user?.email {
            emailLabel.text = email
            emailLabel.textColor = mainTextColor
            emailLabel.textAlignment = NSTextAlignment.center
        }
        if let correctionPoint = user?.correction_point {
            correctionPointLabel.text = "correction points : \(correctionPoint)"
            correctionPointLabel.textColor = mainTextColor
            correctionPointLabel.textAlignment = NSTextAlignment.center
        }
        if let wallet = user?.wallet {
            walletLabel.text = "wallet : \(wallet)"
            walletLabel.textColor = mainTextColor
            walletLabel.textAlignment = NSTextAlignment.center
        }
    }
    
    func fillCursusInfo() {
        cursusInfoStackView.addBackground(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.75))
        cursusInfoStackView.layoutMargins = UIEdgeInsetsMake(20, 10, 20, 10)
        cursusInfoStackView.isLayoutMarginsRelativeArrangement = true
        
        cursusStatusLabel.font = cursusStatusLabel.font.withSize(20)
        cursusStatusLabel.text = "Cursus unavailable"
        cursusStatusLabel.textColor = mainTextColor
        cursusStatusLabel.textAlignment = NSTextAlignment.center
        cursusNameLabel.isHidden = true
        cursusNameLabel.textColor = mainTextColor
        cursusNameLabel.textAlignment = NSTextAlignment.center
        if let cursusId = currentCursusId {
            if let cursus = user?.cursus_users.first(where: { $0.cursus_id == cursusId }) {
                let g = cursus.grade ?? "Novice"
                let l = cursus.level ?? 0.0
                cursusStatusLabel.text = "level : \(l) - \(g)"
                if let name = cursus.cursus?.name {
                    cursusNameLabel.isHidden = false
                    cursusNameLabel.text = "Cursus \(name)"
                }
            }
        }
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = 5
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

