//
//  ContentView.swift
//  BugTracker
//
//  Created by Elijah on 2/6/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import AuthenticationServices
struct ContentView: View {
    @State var appleSignInDelegates: SignInWithAppleDelegate! = nil
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
                    
                
        }.onAppear {
            self.performExistingAccountSetupFlows()
        }
    }
    
    private func performExistingAccountSetupFlows() {
        
        let nonce = self.appleSignInDelegates.randomNonceString()
        let appleRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleRequest.nonce = self.appleSignInDelegates.sha256(nonce)
        
        let requests = [
            appleRequest //,
         //   ASAuthorizationPasswordProvider().createRequest()
        ]
        
        performSignIn(using: requests)
        
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        
        appleSignInDelegates = SignInWithAppleDelegate() { success in
            if success {
              
                print("got success on loginView 🤓")
                
            }else {
                print("did not get success on loginView 🤓")
            }
        }
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.performRequests()
    }
    
    private func peformAuthCheck() {
        let provider = ASAuthorizationAppleIDProvider()
        
        provider.getCredentialState(forUserID: "currentUserIdentifier") { (state, error) in
            
            switch state {
            case .authorized :
                    //credentials are valid
                    print("credentials are valid 🤓")
                break
                
            case .notFound :
                    // credentials not found. Ask to Log In
                    print("credentials not found 🤓")
                break
                
            case .revoked :
                    //credentials revoked. Log them out
                break
                
            case .transferred :
                
                break
                
            default :
                
                break
                
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
