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
@EnvironmentObject var issueObject: IssueHelper
    
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
                Text("\(listIssue.title ?? "Untitled")")
            }
            
        }
        
    }
}

struct IssuesTab_Previews: PreviewProvider {
    static var previews: some View {
        IssuesTab()
    }
}
