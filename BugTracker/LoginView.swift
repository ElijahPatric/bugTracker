//
//  LoginView.swift
//  BugTracker
//
//  Created by Elijah on 4/3/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
            Text("Basic Bug Tracker")
                .font(.largeTitle)
                .font(Font.system(.title, design: .rounded))
                
            Form {
                Section {
                    TextField("password", text: $password)
                }
                Section {
                    SecureField("username", text: $username)
                }
                Section {
                    Button(action: {
                        
                       
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Login")
                                .padding()
                                
                                    
                                
                            Spacer()
                        }
                        
                    }.overlay(Capsule(style: .continuous)
                    .stroke(Color.accentColor, lineWidth: 2))
                }
                
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
