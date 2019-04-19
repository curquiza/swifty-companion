//
//  SkillsTableViewCell.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/18/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var skill: Skill? {
        didSet {
            if let s = skill {
                nameLabel.text = s.name
                nameLabel.font = nameLabel.font.withSize(14)
                let l = s.level ?? 0.0
                levelLabel.text = "\(l)"
                levelLabel.font = levelLabel.font.withSize(14)
            }
        }
    }
}
