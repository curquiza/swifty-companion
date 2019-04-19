//
//  ProjectsTableViewCell.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/18/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    var project: ProjectUser? {
        didSet {
            if let p = project {
                nameLabel.font = nameLabel.font.withSize(14)
                nameLabel.text = p.project?.name ?? "Unknown"
                markLabel.text = "-"
                markLabel.font = markLabel.font.withSize(14)
                if let mark = p.final_mark {
                    markLabel.text = String(mark)
                }
                markLabel.textColor = .black
                if let status = project?.status {
                    if status == "finished" {
                        if let valid = p.validated {
                            if valid == true {
                                markLabel.textColor = .green
                            } else {
                                markLabel.textColor = .red
                            }
                        }
                    }
                }
            }
        }
    }
    
}
