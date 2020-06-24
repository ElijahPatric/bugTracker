//
//  ContentView.swift
//  BugTracker
//
//  Created by Elijah on 2/6/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Firebase
struct ContentView: View {
   
    @State var needsToSignIn = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appleSignInDelegates: SignInWithAppleDelegate
    
    var body: some View {
        Group { if self.appleSignInDelegates.isLoggedIn == true  {
            TabView {
                IssuesTab()
                    .tabItem {
                        VStack {
                            Text("Issues")
                        }
                    }
                SprintTab()
                    .tabItem {
                        VStack {
                            Text("Sprints")
                        }
                    }
                EpicsTab()
                .tabItem {
                    VStack {
                        Text("Epics")
                    }
                }
          
            }
                }else {
                LoginView()
            }
        }
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
