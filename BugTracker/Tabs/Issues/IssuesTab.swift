//
//  IssuesTab.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct IssuesTab: View {

@State var createTicket = false

//uncomment when running
//@EnvironmentObject var issueObject: IssueHelper
    
//comment out when not needing preview. This is just for preview
@State var issueObject = IssueHelper(withListner: true)
    
    var body: some View {

        VStack {
            
            ScrollView(.horizontal) {
                HStack {
                    Button(action:{
                        self.createTicket.toggle()
                    }) {
                        Text("Create Ticket")
                        .multilineTextAlignment(.center)
                        }.padding(.leading, CGFloat(8.0))
                        .sheet(isPresented: $createTicket) { CreateTicket(isPresented: self.$createTicket).environmentObject(self.issueObject)
                            
                    }
                    
                }
            }
            Spacer()
            
            List(issueObject.tickets) { listIssue in
                VStack {
                    HStack {
                        IssueTypeIcon(type: listIssue.type)
                        //Text("\(listIssue.type.rawValue)")
                            //.foregroundColor(self.colorForType(type: listIssue.type))
                            
                        Text("\(listIssue.title ?? "Untitled")")
                        Spacer()
                    }
                    HStack {
                       Spacer()
                       Text("\(self.issueObject.stringForTimestamp(issue: listIssue))")
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .light)))
                        .padding(.trailing, CGFloat(6.0))
                        
                    }
                }
            }
            
            HStack {
                Spacer()
                Text("issues: \(self.issueObject.tickets.count)")
                    
            }
            
        }
        
    }
    
    

    
}

struct IssuesTab_Previews: PreviewProvider {
    
    var issueObject: [String] = ["1","2","3"]
    @State var createTicket = false
    
    static var previews: some View {
        IssuesTab()
 
    }
}
