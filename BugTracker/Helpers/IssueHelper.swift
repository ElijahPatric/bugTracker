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
    
//    static let db = Firestore.firestore()
    
    @Published var tickets: [issue] = []

//    var ticketArray: [issue] = []
    
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
                                     timestamp: Timestamp(date:Date()))
                
//                print("title: \(newIssue.title) 😎")
//                print("issue type: \(newIssue.type.rawValue) 😎")
                self.tickets.append(newIssue)
                
                
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

