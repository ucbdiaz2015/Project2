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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        InstaFeed().fetchPostDetails{ posts //(posts: [InstaFeed.Post]) -> ()
            in
            
            //self.posts = posts
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

