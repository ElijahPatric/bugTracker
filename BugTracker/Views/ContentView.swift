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
    @ObservedObject var appleSignInDelegates: SignInWithAppleDelegate = SignInWithAppleDelegate()
//        { success in
//           if success {
//                
//               print("got success on content view 🤓")
//               //self.needsToSignIn = false
//           }else {
//               print("did not get success on content view 🤓")
//                
//               //self.needsToSignIn = true
//           }
//       }
    
    var isLoggedIn: Bool {
        get {
           
            return Auth.auth().currentUser != nil
        }
    }
    
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
                    
                
        }.onAppear {
            print("on appear content view 🤓")
                
             //self.performExistingAccountSetupFlows()
             //self.peformAuthCheck()
            
            
        }
            }else {
            LoginView()
        }
        }
    }
    
    private func performExistingAccountSetupFlows() {
        
//        appleSignInDelegates = SignInWithAppleDelegate() { success in
//            if success {
//
//                print("got success on content view 🤓")
//                self.needsToSignIn = false
//            }else {
//                print("did not get success on content view 🤓")
//                self.needsToSignIn = true
//            }
//        }
        
        guard self.isLoggedIn == false else{return}
        
        let nonce = self.appleSignInDelegates.randomNonceString()
        appleSignInDelegates.currentNonce = nonce
        let appleRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleRequest.nonce = self.appleSignInDelegates.sha256(nonce)
        
        let requests = [
            appleRequest //,
         //   ASAuthorizationPasswordProvider().createRequest()
        ]
        
        //performSignIn(using: requests)
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.performRequests()
        
    }
    
//    private func performSignIn(using requests: [ASAuthorizationRequest]) {
//
//        let controller = ASAuthorizationController(authorizationRequests: requests)
//        controller.delegate = appleSignInDelegates
//        controller.performRequests()
//    }
    
//    private func peformAuthCheck() {
//        guard Auth.auth().currentUser == nil else{return}
//
//        let provider = ASAuthorizationAppleIDProvider()
//
//        provider.getCredentialState(forUserID: "currentUserIdentifier") { (state, error) in
//
//
//            switch state {
//            case .authorized :
//                    //credentials are valid, no action needed
//                    print("credentials are valid (content view)🤓")
//
//
//                break
//
//            case .notFound :
//                    // credentials not found. Ask to Log In
//                    print("credentials not found (content view)🤓")
//                    //self.needsToSignIn = true
//                break
//
//            case .revoked :
//                    //credentials revoked. Log them out
//                //self.needsToSignIn = true
//                break
//
//            case .transferred :
//                    // not sure what this is. Ask them to log in
//                //self.needsToSignIn = true
//                print("credentials transferred 🤓")
//                break
//
//            default :
//                    // all other cases, ask them to log in
//                break
//
//            }
//
//        }
//
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
