//
//  MediaTableViewController.swift
//  Instagram
//
//  Created by ddd on 9/24/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class MediaTableViewController: UITableViewController {

    var posts: [InstaFeed.Post] = []
    var userID: String?

    
    @IBOutlet weak var profilePicture: UIImageView?
    @IBOutlet weak var numPosts: UILabel?
    @IBOutlet weak var numFollowers: UILabel?
    @IBOutlet weak var numFollowing: UILabel?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        self.tableView.estimatedRowHeight = 2500
        // This line isn't necessary on iOS 8 and above but I left it here to be more explicit
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshData()
    }

    
    // MARK: Refreshing
    
    @IBAction func refreshData(sender: UIRefreshControl) {
        refreshData()
    }
    

    
    func refreshData() {
//        if self.user {
        if let id = self.userID {
    
           
            
            InstaUserProfile().fetchProfileDetails(id) { (header: (InstaUserProfile.ProfileHeader)) -> () in
                
                self.numPosts!.text = (header.postCount as NSNumber).stringValue
                self.numFollowers!.text = (header.followerCount as NSNumber).stringValue
                self.numFollowing!.text = (header.followingCount as NSNumber).stringValue
                self.loadOrFetchProfileImageFor(header.username, profilePicUrl: header.profilePicURL)
                
                self.tableView.tableHeaderView?.reloadInputViews()
            }
            
            
            
            InstaUserProfile().fetchRecentMediaDetails(id){ (posts: [InstaFeed.Post]) -> () in
                self.posts = posts
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                    
            }
            
            
        } else {
            InstaFeed().fetchPostDetails{ (posts: [InstaFeed.Post]) -> () in
                self.posts = posts
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            
            }
                //self.profileHeader = nil
                self.tableView.tableHeaderView = nil
            
        }
        //self.refreshControl?.endRefreshing()
        
    }
    
    var cachedImages = SwiftlyLRU<String, UIImage>(capacity: 15)
    
    
    
    func loadOrFetchProfileImageFor(username: String, profilePicUrl: String) -> Void {
        if let image = cachedImages[username] { // already in cache
            self.profilePicture?.image = image
        } else {
            if let url = NSURL(string: profilePicUrl) { // need to fetch
                
                if let data = NSData(contentsOfURL: url) {
                    if let avatarSquare = UIImage(data:data) {
                        let avatarCircle = UIImage.roundedRectImageFromImage(avatarSquare, imageSize: avatarSquare.size, cornerRadius: avatarSquare.size.width / 2)
                        
                        self.cachedImages[username] = avatarCircle
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.profilePicture?.image = avatarCircle
                            
                        }
                    }
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.posts.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts[section].comments.count + 1
        //return 1
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("MediaCell", forIndexPath: indexPath) as! MediaTableViewCell

            // Configure the cell...
            let post = posts[indexPath.section]
            //print(indexPath.row)
            cell.post = post
            
            print(post.comments)
            
            return cell
            
            
        } else {
            
            let commentCell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
            
            // Configure the cell...
            let comment = posts[indexPath.section].comments[indexPath.row - 1]
            //print(indexPath.row)
            commentCell.commentInfo = comment
            
            return commentCell
        }
        
        
    }

    

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! SectionHeaderTableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell" , forSection: section) as! HeaderTableViewCell
        let post = posts[section]
        cell.post = post
        
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "myHeaderCellTapped:")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        cell.addGestureRecognizer(singleTap)
        cell.userInteractionEnabled = true
        
        
        return cell
    }
    
    
    
    
    @IBAction func myHeaderCellTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended){
            print("myHeader has been tapped by the user.")
            
            
            
            self.performSegueWithIdentifier("ShowProfile", sender: recognizer.view)
            
            
        }
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowProfile" {
            
            let profileViewController = segue.destinationViewController as! MediaTableViewController
            if let selectedUserCell = sender as? SectionHeaderTableViewCell {
                profileViewController.userID = selectedUserCell.userID
                
                
                
//                if profileViewController.childViewControllers.count > 0 {
//                    let headerViewController = profileViewController.childViewControllers[0]
//                    let profileHeaderController = headerViewController as! ProfileHeaderViewController
//                    profileHeaderController.userID = selectedUserCell.userID
//                }

                
                
//                var profileheader = profileViewController.tableView.tableHeaderView as! ProfileHeaderViewController
//                //                    self.tableView.tableHeaderView = nil
//                
//                //profileheader.headerInfo = self.profileHeader
//                profileheader.userID = selectedUserCell.userID
//                profileViewController.tableView.tableHeaderView = profileheader
//                self.tableView.tableHeaderView?.reloadInputViews()
            }
            
            
            
        }
        
    }
    
    
//    override func viewWillAppear(animated: Bool) {
//        
//    }
    

}




