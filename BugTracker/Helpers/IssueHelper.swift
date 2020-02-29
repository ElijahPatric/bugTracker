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

    var ticketArray: [issue] = []
    
    init(withListner:Bool) {
        
        guard withListner == true else {return}
        let db = Firestore.firestore()
        db.collection("Tickets").addSnapshotListener{ documentSnapshot, error in
          guard let snapshot = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          let documents = snapshot.documents
            guard documents.isEmpty == false else {
                //array is empty
                return
            }
            print("how many inits? 😎")
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
                                     timestamp: Date())
                
                
                self.tickets.append(newIssue)
                
                
            }
            
        }
        
    }

    func saveIssue(ticket: issue) {
        let db = Firestore.firestore()
        let docRef = db.collection("AppData").document("HighestTicketNumber")
        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                let dataDescription = document.data() as? [String:Int]
                guard dataDescription != nil else {self.handleNoDataDescription();return}
                let topNumber = dataDescription!["TopNumber"]!
                
                let tempTicket = issue(title: ticket.title,
                description: ticket.description,
                issueID: topNumber,
                points: ticket.points,
                assignee: nil,
                type: ticket.type,
                sprintID: nil,
                epicID: nil,
                status: .open,
                timestamp: Date())
                
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
    
    func handleNoDataDescription() {
        
    }
    
    func handleCreateIssueError() {
        
    }
    
    
}

