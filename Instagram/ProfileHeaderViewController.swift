//
//  ProfileHeaderViewController.swift
//  Instagram
//
//  Created by ddd on 10/10/15.
//  Copyright © 2015 TalentSpark. All rights reserved.


import UIKit

class ProfileHeaderViewController: UIViewController {

    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var NumPosts: UILabel!
    @IBOutlet weak var NumFollowers: UILabel!
    @IBOutlet weak var NumFollowing: UILabel!
    
    var userID: String?
    
    //var headerInfo: InstaUserProfile.ProfileHeader
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            self.refreshData()
    }
    
    func refreshData() {
        if let id = self.userID {
            
            
            InstaUserProfile().fetchProfileDetails(id) { (header: (InstaUserProfile.ProfileHeader)) -> () in
                
                self.NumPosts.text = (header.postCount as NSNumber).stringValue
                self.NumFollowers.text = (header.followerCount as NSNumber).stringValue
                self.NumFollowing.text = (header.followingCount as NSNumber).stringValue
                
                
                self.loadOrFetchImageFor(header.username, profilePicUrl: header.profilePicURL)
                
                

                
                
//                self.tableView.tableHeaderView?.reloadInputViews()
//                
                
                
                
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var cachedImages = SwiftlyLRU<String, UIImage>(capacity: 15)
    
    
    
    func loadOrFetchImageFor(username: String, profilePicUrl: String) -> Void {
        if let image = cachedImages[username] { // already in cache
            self.ProfilePic?.image = image
        } else {
            if let url = NSURL(string: profilePicUrl) { // need to fetch
                
                if let data = NSData(contentsOfURL: url) {
                    if let avatarSquare = UIImage(data:data) {
                        let avatarCircle = UIImage.roundedRectImageFromImage(avatarSquare, imageSize: avatarSquare.size, cornerRadius: avatarSquare.size.width / 2)
                        
                        self.cachedImages[username] = avatarCircle
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.ProfilePic?.image = avatarCircle
                            
                        }
                    }
                }
                
            }
        }
    }


}


//extension UIImage {
//    
//    class func roundedRectImageFromImage(image: UIImage, imageSize: CGSize, cornerRadius: CGFloat)->UIImage {
//        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
//        let bounds = CGRect(origin: CGPointZero, size: imageSize)
//        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
//        image.drawInRect(bounds)
//        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return finalImage
//    }
//    
//}


