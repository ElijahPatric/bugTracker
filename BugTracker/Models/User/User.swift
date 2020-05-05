//
//  UserModel.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation

class User: Codable {
//    var firstName: String
//    var lastName: String
//    var fullName: String {
//        get {
//            return "\(firstName) \(lastName)"
//        }
//    }
//    var accessLevel: permissionLevel

    var username: String?
    var email: String?
    let userID: String
    
    
    init(uid: String, username: String?, email: String?) {
        self.userID = uid
        self.email = email
        self.username = username
    }
    
}
