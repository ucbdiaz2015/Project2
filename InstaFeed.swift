//
//  InstaFeed.swift
//  Instagram
//
//  Created by ddd on 9/20/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public class InstaFeed {
    
    
    let feedURL: String = "https://api.instagram.com/v1/media/popular?client_id=c953ffadb974463f9f6813fc4fc91673"
    //let post =
    
    struct Post {
        let userID: String
        

        let profilePicURL: String
        let username: String
        let created_time: String
        let caption: String
        let likes: Int
        //comments in table view
        //let comments: [[ String : String ]]
        let comments: [Comment]
        
    }
    
    struct Comment {
        let username: String
        let text: String
    }
    
    
    func fetchPostDetails (callback: ([Post]) -> Void) {
        Alamofire.request(.GET, feedURL)
            .responseJSON { _, _, result in
                //let res = response
                self.populatePostInfoWith(result.value, callback: callback)
        }
    }
    

    func populatePostInfoWith (data: AnyObject?, callback: ([Post]) -> Void) {
        let json = JSON(data!).dictionaryValue
        //let json = data!
        var posts = [Post]()
        
        for post in json["data"]!.arrayValue {
            
            var comments = [Comment]()
            for comment in post["comments"]["data"].arrayValue {
                comments.append(Comment(username: comment["username"].stringValue, text: comment["text"].stringValue))
            }
            
            posts.append(Post(
                userID: post["user"]["id"].stringValue,
                profilePicURL: post["user"]["profile_picture"].stringValue,
                username: post["user"]["username"].stringValue,
                created_time: post["created_time"].stringValue,
                caption: post["caption"]["text"].stringValue,
                likes: post["likes"]["count"].intValue,
                comments: comments
            ))
        }
        
        callback(posts)
        
    }
    
    
}
