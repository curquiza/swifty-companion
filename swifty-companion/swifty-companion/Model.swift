//
//  Model.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/10/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let login: String?
    let first_name: String?
    let last_name: String?
    let email: String?
    let location: String?
    let correction_point: Int?
    let wallet: Int?
    
    let image_url: String?
    
    let cursus_users: [CursusUser?]
    let projects_users: [ProjectUser?]
}

struct CursusUser: Codable {
    let cursus_id: Int? // 1 pour le cursus 42, 6 pour la piscineC
    let grade: String?
    let level: Float?
    let skills: [Skill?]
}

struct Skill: Codable {
    let name: String?
    let level: Float?
}

struct ProjectUser: Codable {
    let final_mark: Int?
    let validated: Bool?
    let status: String?
    let project: Project?
    let cursus_ids: [Int?]
    
    private enum CodingKeys: String, CodingKey {
        case final_mark
        case validated = "validated?"
        case status
        case project
        case cursus_ids
    }
}

struct Project: Codable {
    let name: String?
}
