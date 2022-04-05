//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 31/03/22.
//

import Foundation
import FirebaseAuth


final class AuthManager {
    public static let shared = AuthManager()
        
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    //Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
    
}
