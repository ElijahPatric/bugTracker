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
    @Published var issuesForSprint: [issue] = [] 
    
    let db = Firestore.firestore()
    
    init(withListner:Bool) {
        
        guard withListner == true else {return}
        //let db = Firestore.firestore()
        
        db.collection("Tickets").order(by: "timestamp", descending: true).addSnapshotListener { documentSnapshot, error in
          guard let snapshot = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
            let documents = snapshot.documents
            guard documents.isEmpty == false else {
                //array is empty
                return
            }
 
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
        //let db = Firestore.firestore()
        
        db.collection("Sprints").order(by: "startTimestamp", descending: true).addSnapshotListener { documentSnapshot, error in
            
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
       // let db = Firestore.firestore()
        let docRef = db.collection("AppData").document("HighestTicketNumber")
        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                //get a new id number for this new issue
                let dataDescription = document.data() as? [String:Int]
                guard dataDescription != nil else {self.handleNoDataDescription();return}
                var topNumber = dataDescription!["TopNumber"]!
                
                //if existing issue, use same id, otherwise it would make a new issue on every edit
                if existingIssue == true {
                    topNumber = ticket.issueID
                }
                
                //if existing issue, use existing timestamp, otherwise use today's date
                var timestamp = Timestamp(date: Date())
                if existingIssue == true {
                    timestamp = ticket.timestamp
                }
                
                
                let tempTicket = issue(title: ticket.title,
                                       description: ticket.description,
                                       issueID: topNumber,
                                       points: ticket.points,
                                       assignee: nil,
                                       type: ticket.type,
                                       sprintID: ticket.sprintID,
                                       epicID: nil,
                                       status: .open,
                                       timestamp: timestamp)
                
            do {
                try self.db.collection("Tickets").document("\(tempTicket.issueID)").setData(from: tempTicket)
                self.db.collection("AppData").document("HighestTicketNumber").setData(["TopNumber" : tempTicket.issueID + 1])
                } catch {
                    
                    self.handleCreateIssueError()
                }
                
                
        } else {
            print("Document does not exist")
        }
            
        }
    }
    
    func deleteIssue(issue:issue) {
        self.db.collection("Tickets").document("\(issue.id)").delete()
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
// MARK: Sprint Helper Extension
extension IssueHelper: SprintHelper {
    
    func handleCreateSprintError() {
        print("sprint error 🤓")
    }
    
    func shortStringFromTimestamp(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue() as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let dateString = formatter.string(from: date).lowercased()
        
        return dateString
    }
 
    
    func sprintDurationByDates(start:Date,end:Date) -> Int {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start.startOfDay(), to: end.startOfDay())
        
        let days = components.day
        
        return days!
    }

    
    func issuesForSprint(sprint: sprint) -> [issue] {
    
       
            let handler = self.db.collection("Tickets").whereField("sprintID", isEqualTo: sprint.sprintID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents in issuesForSprint func: \(err) 😖")
                    
                } else {
                    
                    self.issuesForSprint = []
                    
                    for document in querySnapshot!.documents {
                        
                        let result = Result {
                            try document.data(as: issue.self)
                        }
                        switch result {
                            case .success(let fIssue):
                                if let fIssue = fIssue {
                                // A `issue` value was successfully initialized from the DocumentSnapshot.
                                    self.issuesForSprint.append(fIssue)
                                } else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                print("Document was not successfully initialized. IssuesForSprint func 🤨")
                            }
                            case .failure(let error):
                                // value could not be initialized from the DocumentSnapshot.
                                print("Error decoding city: \(error)")
                        }
                        
                    }
                  
                    
                }
                  
        }
        
        return performSprintIssueFetch(completionHandler: handler)
        
    }
    
    private func performSprintIssueFetch(completionHandler: Void) -> [issue] {
        
        completionHandler

        
        let arrayToReturn = self.issuesForSprint
        return arrayToReturn
    }
    
    func saveSprint(sprint: sprint, existingSprint: Bool = false) {
      
        let docRef = self.db.collection("AppData").document("HighestSprintNumber")
        
        docRef.getDocument { (document, error) in
            
                
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
                startTimestamp: Timestamp(date: startDate.startOfDay()),
                endTimestamp: Timestamp(date: endDate.startOfDay()),
                title: sprint.title,
                description: sprint.description,
                points: sprint.points)
                
                do {
                    
                    try self.db.collection("Sprints").document("\(tempSprint.sprintID)").setData(from: tempSprint)
                    self.db.collection("AppData").document("HighestSprintNumber").setData(["TopNumber" : tempSprint.sprintID + 1])
                    
                } catch {
                    self.handleCreateSprintError()
                }
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

