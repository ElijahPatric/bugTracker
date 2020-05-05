//
//  UserDataKeychain.swift
//  BugTracker
//
//  Created by Elijah on 5/5/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation

struct UserDataKeychain: Keychain {
  // Make sure the account name doesn't match the bundle identifier!
  var account = "com.ElijahPatric.BugTracker.Details"
  var service = "userIdentifier"

  typealias DataType = UserData
}
