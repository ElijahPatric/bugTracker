//
//  IssueHelper.swift
//  BugTracker
//
//  Created by Elijah on 2/15/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI 
class IssueHelper: ObservableObject {
        
    @Published var tickets: [issue] = []
    @Published var sprints: [sprint] = []
    
    init(withListner:Bool) {
        
        guard withListner == true else {return}
        let db = Firestore.firestore()
        
        db.collection("Tickets").addSnapshotListener { documentSnapshot, error in
          guard let snapshot = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          let documents = snapshot.documents
            guard documents.isEmpty == false else {
                //array is empty
                return
            }
 //           print("how many inits? 😎")
            self.tickets = []
            
            for document in documents {
                
                let docData = document.data()
                
                let typeString = docData["type"] as! String
                let statusString = docData["status"] as! String
                
                let newIssue = issue(title: (docData["title"] as! String),
                                     description: (docData["description"] as! String),
                                     issueID: docData["issueID"] as! Int,
                                     points: (docData["points"] as! Int),
                                     assignee: nil,
                                     type: issueType.init(rawValue: typeString) ?? issueType.none,
                                     sprintID: nil,
                                     epicID: nil,
                                     status: issueStatus.init(rawValue: statusString) ?? issueStatus.open,
                                     timestamp: docData["timestamp"] as! Timestamp)
                

                self.tickets.append(newIssue)
                
                
            }
            
        }
        
    }
    
    init(withListnerForSprints:Bool) {
        
        guard withListnerForSprints == true else {return}
        let db = Firestore.firestore()
        
        db.collection("Sprints").addSnapshotListener { documentSnapshot, error in
            
            guard let snapshot = documentSnapshot else {
                print("error fetching document: \(error!)")
                return
            }
            
            let documents = snapshot.documents
            guard documents.isEmpty == false else {
                //array is empty
                return
            }
            
            self.sprints = []
            
            for document in documents {
                let docData = document.data()
                
                var title = docData["title"] as? String
                if title == nil {
                    title = ""
                }
                
                var description = docData["description"] as? String
                
                if description == nil {
                    description = ""
                }
                
                let newSprint = sprint(sprintID: docData["sprintID"] as! Int,
                                       duration: docData["duration"] as! Int,
                                       startTimestamp: docData["startTimestamp"] as! Timestamp,
                                       endTimestamp: docData["endTimestamp"] as! Timestamp,
                                       title: title!,
                                       description: description!,
                                       points: 0)
                
                self.sprints.append(newSprint)
                
            }
            
        }
        
    }

    func saveIssue(ticket: issue, existingIssue: Bool = false) {
        let db = Firestore.firestore()
        let docRef = db.collection("AppData").document("HighestTicketNumber")
        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                //get a new id number for this new issue
                let dataDescription = document.data() as? [String:Int]
                guard dataDescription != nil else {self.handleNoDataDescription();return}
                var topNumber = dataDescription!["TopNumber"]!
                
                //if existing issue, use same id, otherwise it would make a new issue
                if existingIssue == true {
                    topNumber = ticket.issueID
                }
                
                let tempTicket = issue(title: ticket.title,
                description: ticket.description,
                issueID: topNumber,
                points: ticket.points,
                assignee: nil,
                type: ticket.type,
                sprintID: nil,
                epicID: nil,
                status: .open,
                timestamp: Timestamp(date:Date()))
                
            do {
              try db.collection("Tickets").document("\(tempTicket.issueID)").setData(from: tempTicket)
              db.collection("AppData").document("HighestTicketNumber").setData(["TopNumber" : tempTicket.issueID + 1])
                } catch {
                    
                    self.handleCreateIssueError()
                }
                
                
        } else {
            print("Document does not exist")
        }
            
        }
    }
    
    func listenForUpdates() {
        
        
        
    }
    
    func handleNoDataDescription() {
        print("no data description error 🤓")
    }
    
    func handleCreateIssueError() {
        
    }
    
    func stringForTimestamp(issue: issue) -> String {
        
        let issueStamp = issue.timestamp
        let date = issueStamp.dateValue() as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM.d, yyyy h:mma"
        let dateString = formatter.string(from: date).lowercased()
        
        return dateString
        
    }
    
}
extension IssueHelper: SprintHelper {
    
    func handleCreateSprintError() {
        print("sprint error 🤓")
    }
 
    
    func sprintDurationByDates(start:Date,end:Date) -> Int {
        
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start.startOfDay(), to: end.startOfDay())
        
        let days = components.day
        
        return days!
    }
    
    func saveSprint(sprint: sprint, existingSprint: Bool = false) {
        let db = Firestore.firestore()
        let docRef = db.collection("AppData").document("HighestSprintNumber")
        
        docRef.getDocument { (document, error) in
            
  //          if let document = document, document.exists {
                
                //get a new id number for this new sprint
        let dataDescription = document!.data() as? [String:Int]
                guard dataDescription != nil else {self.handleNoDataDescription();return}
                var topNumber = dataDescription!["TopNumber"]!
                
                //if existing sprint, use same id, otherwise it would make a new sprint
                if existingSprint == true {
                    topNumber = sprint.sprintID
                }
                
                //get length of sprint
                let startDate = sprint.startTimestamp.dateValue() as Date
                let endDate = sprint.endTimestamp.dateValue() as Date
                let duration = self.sprintDurationByDates(start: startDate, end: endDate)
                
                
                let tempSprint: sprint = type(of: sprint).init(
                sprintID: topNumber,
                duration: duration,
                startTimestamp: Timestamp(date: Date()),
                endTimestamp: Timestamp(date: Date()),
                title: sprint.title,
                description: sprint.description,
                points: sprint.points)
                
                do {
                    
                  try db.collection("Sprints").document("\(tempSprint.sprintID)").setData(from: tempSprint)
                    db.collection("AppData").document("HighestSprintNumber").setData(["TopNumber" : tempSprint.sprintID + 1])
                    
                } catch {
                    self.handleCreateSprintError()
                }
               
                
//            } else {
//                print("Document does not exist")
//            }
            
        }
    }
}
extension Date {
    func startOfDay() -> Date {
        let calendar = Calendar.current
        let newDate = calendar.startOfDay(for: self)
        
        return newDate
    }
}

