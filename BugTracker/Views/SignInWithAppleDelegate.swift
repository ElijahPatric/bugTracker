//
//  SignInWithAppleDelegate.swift
//  BugTracker
//
//  Created by Elijah on 5/4/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit
import Firebase
import SwiftUI
class SignInWithAppleDelegate: NSObject, ObservableObject {
    
    @Published var loginErrorOccurred = false
    @Published var isLoggedIn = false
    var handle: AuthStateDidChangeListenerHandle?
    var currentNonce: String?
    var userID = "currentUserIdentifier"
    //    private var signInSucceeded: (Bool) -> Void?
    
//    init(onSignedIn: @escaping (Bool) -> Void) {
//        self.signInSucceeded = onSignedIn
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//          print("listner is attached 🤓")
//            if auth.currentUser == nil {
//                print("user is nil")
//                self.isLoggedIn = false
//            }else {
//                print("user is NOT nil")
//                self.isLoggedIn = true
//            }
//        }
//
//    }
    
    override init() {
        super.init()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          print("listner is attached 🤓")
            if auth.currentUser == nil {
                print("user is nil")
                self.isLoggedIn = false
            }else {
                print("user is NOT nil")
                self.isLoggedIn = true
            }
        }

    }
}

extension SignInWithAppleDelegate: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
       
        /// ////////////// initial checks
        print("got to did complete auth 🤓")
        var fireCredential: OAuthCredential?
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent. 🤓")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token 🤓")
                self.isLoggedIn = false
              return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription) 🤓")
                self.isLoggedIn = false
              return
            }
            
            fireCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
            rawNonce: nonce)
        }
        
        ///////////////////////////////////////
        
        switch authorization.credential {
            
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            
            if let _ = appleIdCredential.fullName, let _ = appleIdCredential.email {
                
                registerNewAccount(credential: appleIdCredential,fireCredential: fireCredential!)
                
            } else {
                self.signInWithExistingAccount(credential: appleIdCredential,fireCredential: fireCredential!)
            }
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            self.signInWithUserPassword(credential: passwordCredential)
            break
            
        default:
            break
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //called, among other cases, if cancel is selected
        print("Sign in with Apple errored: \(error) 🤓")
        self.isLoggedIn = false
//        self.signInSucceeded(false)
    }
    
    func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential, fireCredential: OAuthCredential? = nil) {
        
        //if this method is called, we should have a fully registered account
        // if we don't we can look in keychain for credentials and re-run setup
        print("got to sign in with existing account 🤓")
        // Sign in with Firebase.
        Auth.auth().signIn(with: fireCredential!) { (authResult, error) in
            if (error != nil) {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
                
                print("localized error description: \(error?.localizedDescription) 🤓")
 //               self.signInSucceeded(false)
                self.loginErrorOccurred = true
                self.isLoggedIn = false
            return
          }
          // User is signed in to Firebase with Apple.
          // ...
            self.isLoggedIn = true
 //           self.signInSucceeded(true)
        }
        
    }
    
    func registerNewAccount(credential: ASAuthorizationAppleIDCredential, fireCredential: OAuthCredential? = nil) {
        print("got to register new account 🤓")
        let userData = UserData(email: credential.email!,
                                name: credential.fullName!,
                                identifier: credential.user)
        
        let keychain = UserDataKeychain()
        
        do {
            try keychain.store(userData)
        }catch {
            print("error saving to keychain 🤓")
            self.isLoggedIn = false
            //self.signInSucceeded(false)
        }
        print("got past keychain code 🤓")
        //reach out to your web api and store credentials
        // Sign in with Firebase.
        Auth.auth().signIn(with: fireCredential!) { (authResult, error) in
            if (error != nil) {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
                
                print("localized error description: \(error?.localizedDescription) 🤓")
               // self.signInSucceeded(false)
                self.isLoggedIn = false
            return
          }
          // User is signed in to Firebase with Apple.
          // ...
          //  self.signInSucceeded(true)
            self.isLoggedIn = true
        }
        
    }
    
    func signInWithUserPassword(credential: ASPasswordCredential) {
        
        
//        self.signInSucceeded(true)
    }
    
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }
      print("this is what result is: \(result)")
      return result
    }
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

    
