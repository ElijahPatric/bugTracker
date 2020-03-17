//
//  IssueModel.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation
import FirebaseFirestore
struct issue: Codable, Identifiable, Hashable {
    
    
    static func == (lhs: issue, rhs: issue) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var id:Int {
        get {
            return issueID
        }
    }
    var title: String?
    var description: String?
    var issueID: Int
    var points: Int?
    var assignee: user?
    var type: issueType
    var sprintID: Int?
    var epicID: Int?
    var status: issueStatus
    var timestamp: Timestamp
    
    
}
