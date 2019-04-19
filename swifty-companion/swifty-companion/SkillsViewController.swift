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

        /* Background */
        if let image = UIImage(named: "42_background") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        skillsTableView.backgroundColor = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillsTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        cell.skill = self.skills[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
