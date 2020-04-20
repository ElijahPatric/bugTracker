//
//  Sprint.swift
//  BugTracker
//
//  Created by Elijah on 4/20/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct sprint: Codable, Identifiable, Hashable {
    
    
    static func == (lhs: sprint, rhs: sprint) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var id:Int {
        get {
            return sprintID
        }
    }
    var sprintID: Int
    var duration: Int
    var startTimestamp: Timestamp
    var endTimestamp: Timestamp
    var title: String?
    var description: String?
    var points: Int?
    
    
    
}
