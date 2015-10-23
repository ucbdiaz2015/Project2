//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by ddd on 10/10/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var numPosts: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    var headerInfo: InstaUserProfile.ProfileHeader? {
        didSet {
            if let setHeader = headerInfo {
               
                //(setPost.likes as NSNumber).stringValue
                
                
//                numPosts.text = "21"
                self.numPosts.text = (setHeader.postCount as NSNumber).stringValue
                self.numFollowers.text = (setHeader.followerCount as NSNumber).stringValue
                self.numFollowing.text = (setHeader.followingCount as NSNumber).stringValue
             
                
                
                loadOrFetchImageFor(setHeader.username, profilePicUrl: setHeader.profilePicURL)
                
            }
        }
    }
    
    var cachedImages = SwiftlyLRU<String, UIImage>(capacity: 15)
    
    
    
    func loadOrFetchImageFor(username: String, profilePicUrl: String) -> Void {
        if let image = cachedImages[username] { // already in cache
            self.profilePic?.image = image
        } else {
            if let url = NSURL(string: profilePicUrl) { // need to fetch

                if let data = NSData(contentsOfURL: url) {
                    if let avatarSquare = UIImage(data:data) {
                        let avatarCircle = UIImage.roundedRectImageFromImage(avatarSquare, imageSize: avatarSquare.size, cornerRadius: avatarSquare.size.width / 2)

                        self.cachedImages[username] = avatarCircle

                        dispatch_async(dispatch_get_main_queue()) {
                            self.profilePic?.image = avatarCircle

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



