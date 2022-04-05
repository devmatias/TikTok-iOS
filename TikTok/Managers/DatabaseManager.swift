//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 31/03/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    //Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
    
}
