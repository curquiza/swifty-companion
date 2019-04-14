//
//  APIController.swift
//  swifty-companion
//
//  Created by Clementine URQUIZAR on 4/10/19.
//  Copyright © 2019 Clementine URQUIZAR. All rights reserved.
//

import Foundation
import p2_OAuth2

class APIController {
    
    var oauth2: OAuth2ClientCredentials?
    var api42Delegate: API42Delegate?
    
    init(oauth2: OAuth2ClientCredentials?, delegate: API42Delegate?) {
        self.oauth2 = oauth2
        self.api42Delegate = delegate
    }
    
    func getUserRequest(login: String) {
        let escapedLogin = login.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(escapedLogin)") else { return }
        guard let req = oauth2?.request(forURL: url) else { return }
        let task = oauth2?.session.dataTask(with: req) { data, response, error in
            if let e = error {
                DispatchQueue.main.async {
                    self.api42Delegate?.badRequestError(error: e)
                }
            }
            else if let d = data {
                do {
                    let result = try JSONDecoder().decode(User.self, from: d)
                    DispatchQueue.main.async {
                        self.api42Delegate?.fetchUser(userResult: result)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.api42Delegate?.noUserError()
                    }
                }
            }
        }
        task?.resume()
    }
    
}
