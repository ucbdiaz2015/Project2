//
//  ViewController.swift
//  Instagram
//
//  Created by ddd on 9/20/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var posts: [InstaFeed.Post] = []
    //var userHeader: InstaUserProfile.ProfileHeader
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        InstaFeed().fetchPostDetails{ (posts: [InstaFeed.Post]) -> ()
//            in
//            
//            self.posts = posts
//            
//            InstaUserProfile().fetchProfileDetails (self.posts[0].userID)  { (header: InstaUserProfile.ProfileHeader) -> () in
//            }
//            InstaUserProfile().fetchRecentMediaDetails(self.posts[0].userID)  { (userPosts: [InstaUserProfile.Post]) -> () in
//            }
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

