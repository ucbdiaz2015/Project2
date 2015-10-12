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
    //var userPosts: [InstaUserProfile.Post] = []
    var user: Bool = false
    var userID: String?
    var profileHeader: InstaUserProfile.ProfileHeader?
    
    
//    @IBOutlet weak var postHeaderCell: HeaderTableViewCell!
    
    
    
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
                    self.profileHeader = header

//                    self.tableView.registerClass(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeader")
//                    var profileheader = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("ProfileHeader") as! ProfileHeaderView
                    
                    var profileheader = self.tableView.tableHeaderView as! ProfileHeaderView
                    //self.tableView.tableHeaderView = nil
                    
//                    profileheader.headerInfo = self.profileHeader
                    
                    self.tableView.tableHeaderView = profileheader
                    self.tableView.tableHeaderView?.reloadInputViews()
                    
                    
                    
//                    let cellTableViewHeader = self.tableView.dequeueReusableCellWithIdentifier("ProfileHeader") as! ProfileHeaderView
//                    cellTableViewHeader.headerInfo = self.profileHeader
//                    self.tableView.tableHeaderView = cellTableViewHeader
//                    self.tableView.tableHeaderView?.reloadInputViews()

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
                self.profileHeader = nil
                self.tableView.tableHeaderView = nil
                
        }
        //self.refreshControl?.endRefreshing()
        
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

    
//    func viewForProfileHeader() -> UIView? {
//        let headerView = tableView. as! ProfileHeaderView
//        let profileHeader = self.profileHeader
//        cell.headerInfo
//        
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell" , forSection: section) as! HeaderTableViewCell
        let post = posts[section]
        cell.post = post
        
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "myHeaderCellTapped:")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        cell.addGestureRecognizer(singleTap)
        cell.userInteractionEnabled = true
        
        //cell.addGestureRecognizer(UITapGestureRecognizer())
        
//
        
        return cell
    }
    
    @IBAction func myHeaderCellTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended){
            print("myHeader has been tapped by the user.")
            
            
            
            self.performSegueWithIdentifier("ShowProfile", sender: recognizer.view)
            
            
        }
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowProfile" {
            
            let profileViewController = segue.destinationViewController as! MediaTableViewController
            if let selectedUserCell = sender as? HeaderTableViewCell {
//                let indexPath = tableView.indexPathForCell(selectedUserCell)!
//                let selectedUser = posts[indexPath.row].userID
                profileViewController.userID = selectedUserCell.userID
                profileViewController.user = true
                
                
                
                
                InstaUserProfile().fetchProfileDetails(selectedUserCell.userID) { (header: (InstaUserProfile.ProfileHeader)) -> () in
                    profileViewController.profileHeader = header
                    
                    
                    
//                    var profileheader = profileViewController.tableView.tableHeaderView as! ProfileHeaderView
//                    profileheader.headerInfo = profileViewController.profileHeader
//                    
//                    profileViewController.tableView.tableHeaderView = profileheader
//                    profileViewController.tableView.tableHeaderView?.reloadInputViews()
//                    
                }

                
                //self.refreshData()
            }
        } else {
            self.user = false
            self.profileHeader = nil
            
//            self.refreshData()
            //hide profile header
        }
        
    }
    
    
//    override func viewWillAppear(animated: Bool) {
//        
//    }
    

}
