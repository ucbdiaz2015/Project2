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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.estimatedRowHeight = 2500
        // This line isn't necessary on iOS 8 and above but I left it here to be more explicit
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        InstaFeed().fetchPostDetails{ (posts: [InstaFeed.Post]) -> () in
            self.posts = posts
            self.tableView.reloadData()
            
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func refreshData(sender: UIRefreshControl) {
        refreshData()
    }
    
    func refreshData() {
        InstaFeed().fetchPostDetails{ (posts: [InstaFeed.Post]) -> () in
            self.posts = posts
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
        }
        //self.refreshControl?.endRefreshing()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Refreshing
//    @IBAction func refreshData(sender: UIRefreshControl) {
//        refreshFromParse()
//    }
//    
//    func refreshFromParse() {
//        // Load initial data from Parse
//        // https://www.parse.com/docs/ios/guide#queries-basic-queries
//        let query = PFQuery(className:"Note")
//        query.addDescendingOrder("updatedAt")
//        query.findObjectsInBackgroundWithBlock {
//            (notes, error) -> Void in
//            
//            if error == nil {
//                print("Successfully retrieved \(notes!.count) notes.")
//                if let notes = notes {
//                    self.notes = notes
//                    self.tableView.reloadData()
//                    self.refreshControl?.endRefreshing()
//                }
//            } else {
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//    }
    
    
    

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
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell" , forSection: section) as! HeaderTableViewCell
        let post = posts[section]
        cell.post = post
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
