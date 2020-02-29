//
//  ContentView.swift
//  BugTracker
//
//  Created by Elijah on 2/6/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
