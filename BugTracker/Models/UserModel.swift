//
//  UserModel.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation

struct user: Codable {
    var firstName: String
    var lastName: String
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    var username: String
    var email: String?
    let userID: UUID
    var accessLevel: permissionLevel
}
