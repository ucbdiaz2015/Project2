//
//  InstaUserProfile.swift
//  Instagram
//
//  Created by ddd on 9/20/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public class InstaUserProfile: InstaFeed {
    
    
    
    struct ProfileHeader {
        let profilePicURL: String
        let username: String
        
        let postCount: Int
        let followerCount: Int
        let followingCount: Int
        
    }
    
//    struct Post {
//        let userID: String
//        
//        
//        let profilePicURL: String
//        let username: String
//        let created_time: String
//        
//        let postImageURL: String
//        let caption: String
//        let likes: Int
//        //comments in table view
//        let comments: [Comment]
//    }
//    
//    struct Comment {
//        let username: String
//        let text: String
//    }
    
    
    //https://api.instagram.com/v1/users/{user_id}/?client_id=c953ffadb974463f9f6813fc4fc91673
    
    func fetchProfileDetails (userID : String, callback: (ProfileHeader) -> Void) {
        let profileURL = "https://api.instagram.com/v1/users/" + userID + "/?client_id=c953ffadb974463f9f6813fc4fc91673"
        
        Alamofire.request(.GET, profileURL).responseJSON { _, _, result in
                    //let res = response
            self.populateProfileInfoWith(result.value, callback: callback)
        }
    }
    
    func populateProfileInfoWith(data: AnyObject?, callback: (ProfileHeader) -> Void) {
        let json = JSON(data!).dictionaryValue
        //let json = data!
        let data = json["data"]!.dictionaryValue
        let header = ProfileHeader(profilePicURL: data["profile_picture"]!.stringValue, username: data["username"]!.stringValue, postCount: data["counts"]!.dictionaryValue["media"]!.intValue, followerCount: data["counts"]!.dictionaryValue["followed_by"]!.intValue, followingCount: data["counts"]!.dictionaryValue["follows"]!.intValue)
    
        callback(header)

    }
    
    
    

    // https://api.instagram.com/v1/users/{user_id}/media/recent/?client_id=c953ffadb974463f9f6813fc4fc91673
    func fetchRecentMediaDetails (userID : String, callback: ([Post]) -> Void ){
        let recentMediaURL = "https://api.instagram.com/v1/users/" + userID + "/media/recent/?client_id=c953ffadb974463f9f6813fc4fc91673"
        
        Alamofire.request(.GET, recentMediaURL).responseJSON { _, _, result in
            //let res = response
            self.populateRecentMediaWith(result.value, callback: callback)
        }
    }
    
    func populateRecentMediaWith(data: AnyObject?, callback: ([Post]) -> Void) {
        let json = JSON(data!).dictionaryValue
        //let json = data!
        var posts = [Post]()
    
        for post in json["data"]!.arrayValue {
            
            var comments = [Comment]()
            for comment in post["comments"]["data"].arrayValue {
                comments.append(Comment(username: comment["username"].stringValue, text: comment["text"].stringValue))
            }
            
            posts.append(Post(
                postID: post["id"].stringValue,
                userID: post["user"]["id"].stringValue,
                profilePicURL: post["user"]["profile_picture"].stringValue,
                username: post["user"]["username"].stringValue,
                created_time: post["created_time"].stringValue,
                postImageURL: post["images"]["standard_resolution"]["url"].stringValue,
                caption: post["caption"]["text"].stringValue,
                likes: post["likes"]["count"].intValue,
                comments: comments
            ))
        }
        callback(posts)
    
    }

}