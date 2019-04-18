//
//  ProjectsViewController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/18/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projectsUser: [ProjectUser] = []
    
    @IBOutlet weak var projectsTableView: UITableView! {
        didSet {
            projectsTableView.delegate = self
            projectsTableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Projects view loaded]")
        
        /* Background */
        guard let image = UIImage(named: "42_background") else { return }
        self.view.backgroundColor = UIColor(patternImage: image)
        projectsTableView.backgroundColor = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectsTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        cell.project = self.projectsUser[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
