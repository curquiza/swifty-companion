//
//  Model.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/10/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let email: String
}
