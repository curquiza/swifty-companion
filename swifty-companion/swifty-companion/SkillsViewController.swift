//
//  SkillsViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/18/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit

class SkillsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var skills: [Skill] = []
    
    @IBOutlet weak var skillsTableView: UITableView! {
        didSet {
            skillsTableView.delegate = self
            skillsTableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Skills view loaded]")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillsTableViewCell
        cell.skill = self.skills[indexPath.row]
        return cell
    }
    
    
}
