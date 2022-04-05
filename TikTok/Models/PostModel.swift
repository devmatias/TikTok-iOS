//
//  PostModel.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 31/03/22.
//

import Foundation

struct PostModel {
    let identifier: String
    
    let user = User(
        username: "kanyewest",
        profilePictureURL: nil,
        identifier: UUID().uuidString
    )
    
    var isLikedByCurrentUser = false
    
    //Cria um Array de PostModel cada um com um identificador
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
            
        }
        return posts
    }
}
