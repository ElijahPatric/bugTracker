//
//  UserData.swift
//  BugTracker
//
//  Created by Elijah on 5/5/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation

/// Represents the details about the user which were provided during initial registration.
struct UserData: Codable {
  /// The email address to use for user communications.  Remember it might be a relay!
  let email: String

  /// The components which make up the user's name.
  let name: PersonNameComponents

  /// The team scoped identifier Apple provided to represent this user.
  let identifier: String

  /// Returns the localized name for the person
  func displayName(style: PersonNameComponentsFormatter.Style = .default) -> String {
    PersonNameComponentsFormatter.localizedString(from: name, style: style)
  }
}
