//
//  HeaderTableViewCell.swift
//  Instagram
//
//  Created by ddd on 9/27/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit
import DateTools

class SectionHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    var userID: String!
    
    
    //self.delegate = self
    //MediaTableViewController.delegate = self
    
    
    var post: InstaFeed.Post? {
        didSet {
            if let setPost = post {
                
                userID = setPost.userID
                
                username.text = setPost.username

                
                let date = NSDate(timeIntervalSince1970: (setPost.created_time as NSString).doubleValue)
                let timeAgo = NSDate().shortTimeAgoSinceDate(date)
                timestamp.text = timeAgo
                
                
//                if let url = NSURL(string: setPost.profilePicURL) {
//                    if let data = NSData(contentsOfURL: url) {
//                        profilePic.contentMode = UIViewContentMode.ScaleAspectFit
//                        profilePic.image = UIImage(data: data)
//                    
//                    }
//                
//                }
                
                loadOrFetchImageFor(setPost.userID, profilePicUrl: setPost.profilePicURL, cell: self)
              
                
                
                
                
//                let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "myHeaderCellTapped:")
//                singleTap.numberOfTapsRequired = 1
//                singleTap.numberOfTouchesRequired = 1
//                self.addGestureRecognizer(singleTap)
//                self.userInteractionEnabled = true
            }
        }
    }

    
    
    @IBAction func myHeaderCellTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended){
            print("myUIImageView has been tapped by the user.")

            //self.performSegueWithIdentifier("ShowProfile", sender: self)
            
            //self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("secondStoryBoardName") as MediaTableViewController, animated: true)
          
        }
    }
    
    
    
    //override func performSegueWithIdentifier()
    
    
    var cachedImages = SwiftlyLRU<String, UIImage>(capacity: 24)
    
    
    
    func loadOrFetchImageFor(userID: String, profilePicUrl: String, cell: SectionHeaderTableViewCell) -> Void {
        if let image = cachedImages[userID] { // already in cache
            cell.profilePic?.image = image
        } else {
            if let url = NSURL(string: profilePicUrl) { // need to fetch
                //print("HERES THE URL!!!!!!!!!")
                //print(url)
                //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0))  {
                if let data = NSData(contentsOfURL: url) {
                    //print("DATA!!!!!!!")
                    if let avatarSquare = UIImage(data:data) {
                        print("Square")
                        let avatarCircle = UIImage.roundedRectImageFromImage(avatarSquare, imageSize: avatarSquare.size, cornerRadius: avatarSquare.size.width / 2)
                        
                        //self.cachedImages[userID] = avatarSquare
                        self.cachedImages[userID] = avatarCircle
                        
                        // Because this happens asynchronously in the background, we need to check that by the time we get here
                        // that the cell that requested the image is still the one that is being displayed.
                        // If it is not, we would have cached the image for the future but we will not display it for now.
                        if(cell.userID == userID) {
                            dispatch_async(dispatch_get_main_queue()) {
                                cell.profilePic?.image = avatarCircle
                                //cell.imageView?.image = avatarSquare
                                
                            }
                        }
                    }
                }
            }
        }
    }

    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



extension UIImage {

    class func roundedRectImageFromImage(image: UIImage, imageSize: CGSize, cornerRadius: CGFloat)->UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let bounds = CGRect(origin: CGPointZero, size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.drawInRect(bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage
    }

}

