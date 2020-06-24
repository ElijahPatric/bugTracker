//
//  IssuesTab.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import Firebase
import AuthenticationServices
struct IssuesTab: View {

@State var createTicket = false
@State var selectedIssue: issue?
@State var issueIsSelected: Bool = false
var listIssueType: issueType = .none
@State var loginPresented: Bool = false
@ObservedObject var helper = IssueHelper(withListner: true)
@ObservedObject var appleSignInDelegates: SignInWithAppleDelegate = SignInWithAppleDelegate()
    

    var body: some View {

        VStack {
                HStack {
                    Button(action:{
                        self.createTicket.toggle()
                        
                        }) {
                        Text("Create issue")
                         .multilineTextAlignment(.center)
                        }.padding(.leading, CGFloat(8.0))
                        .sheet(isPresented: $createTicket) { CreateTicket(isPresented: self.$createTicket)}
                    Spacer()
                    Button(action: {
                        
                        let firebaseAuth = Auth.auth()
                        do {
                            self.appleSignInDelegates.isLoggedIn = false
                          try firebaseAuth.signOut()
                          
                        } catch let signOutError as NSError {
                          print ("Error signing out")
                        }
                        
                    }) {
                        Text("Log Out")
                    }
                   
                }
            
            Spacer()
     
            List(helper.tickets,selection: $selectedIssue) { listIssue in
                VStack {
                    HStack {
                        Text("\(String(listIssue.type.rawValue.first!))")
                            .foregroundColor(self.colorForType(type: listIssue.type))
                            .font(Font.system(.title, design: .rounded))
                        Text("\(listIssue.title ?? "Untitled")")
                        Spacer()
                    }
                    HStack {
                       Spacer()
                       Text("\(self.helper.stringForTimestamp(issue: listIssue))")
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .light)))
                        .padding(.trailing, CGFloat(6.0))
                        
                    }

                }.contextMenu {
                    
                    Button(action: {
                        self.selectedIssue = listIssue
                        self.issueIsSelected.toggle()
                    }) {
                        Text("Edit")
                        Image(systemName: "pencil.circle")
                    }
                    Button(action: {
                        self.helper.deleteIssue(issue: listIssue)
                    }) {
                        Text("Delete")
                        Image(systemName: "trash.circle")
                            
                    }
                }

            }.sheet(isPresented: self.$issueIsSelected) { EditTicket(editIssue: self.$selectedIssue,isPresented: self.$issueIsSelected)}
            HStack {
                Spacer()
                Text("issues: \(self.helper.tickets.count)")
                    
            }
        }
        
    }
    
    
    func colorForType(type: issueType) -> Color {
        
        switch type {
        case .bug:
            return .red
        case .none:
            return .gray
        case .feature:
            return .orange
        case .question:
            return .green
        case .support:
            return .blue
        
        }
    }
    

    
}

struct IssuesTab_Previews: PreviewProvider {
    
    var helper: [String] = ["1","2","3"]
    @State var createTicket = false
    
    static var previews: some View {
        IssuesTab()
 
    }
}
