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
class SignInWithAppleDelegate: NSObject {
    
    var currentNonce: String?
    private let signInSucceeded: (Bool) -> Void
    
    init(onSignedIn: @escaping (Bool) -> Void) {
        self.signInSucceeded = onSignedIn
    }
    
}

extension SignInWithAppleDelegate: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        /// ////////////// initial checks
        var fireCredential: OAuthCredential?
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent. 🤓")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token 🤓")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription) 🤓")
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
        print("Sign in with Apple errored: \(error) 🤓")
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
                self.signInSucceeded(false)
            return
          }
          // User is signed in to Firebase with Apple.
          // ...
            self.signInSucceeded(true)
        }
        
        //self.signInSucceeded(true)
        
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
            self.signInSucceeded(false)
        }
        
        //reach out to your web api and store credentials
        // Sign in with Firebase.
        Auth.auth().signIn(with: fireCredential!) { (authResult, error) in
            if (error != nil) {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
                
                print("localized error description: \(error?.localizedDescription) 🤓")
                self.signInSucceeded(false)
            return
          }
          // User is signed in to Firebase with Apple.
          // ...
            self.signInSucceeded(true)
        }
        
    }
    
    func signInWithUserPassword(credential: ASPasswordCredential) {
        
        
        self.signInSucceeded(true)
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

    
