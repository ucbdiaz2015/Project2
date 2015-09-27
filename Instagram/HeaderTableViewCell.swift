//
//  HeaderTableViewCell.swift
//  Instagram
//
//  Created by ddd on 9/27/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    
    var post: InstaFeed.Post? {
        didSet {
            if let setPost = post {
                username.text = setPost.username
                timestamp.text = setPost.created_time
                
                
                if let url = NSURL(string: setPost.profilePicURL) {
                    if let data = NSData(contentsOfURL: url) {
                        profilePic.contentMode = UIViewContentMode.ScaleAspectFit
                        profilePic.image = UIImage(data: data)
                    }
                }
                
                loadOrFetchImageFor(post!.userID, profilePicUrl: post!.profilePicURL, cell: self)
                
            }
        }
    }

    var cachedImages = SwiftlyLRU<String, UIImage>(capacity: 15)
    
    
    
    func loadOrFetchImageFor(userID: String, profilePicUrl: String, cell: HeaderTableViewCell) -> Void {
        if let image = cachedImages[userID] { // already in cache
            cell.profilePic?.image = image
        } else {
            if let url = NSURL(string: profilePicUrl) { // need to fetch
                //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0))  {
                if let data = NSData(contentsOfURL: url) {
                    if let avatarSquare = UIImage(data:data) {
                        //   let avatarCircle = UIImage.roundedRectImageFromImage(avatarSquare, imageSize: avatarSquare.size, cornerRadius: avatarSquare.size.width / 2)
                        //     self.cachedImages.updateValue(avatarCircle, forKey: login)
                        self.cachedImages[userID] = avatarSquare
                        // Because this happens asynchronously in the background, we need to check that by the time we get here
                        // that the cell that requested the image is still the one that is being displayed.
                        // If it is not, we would have cached the image for the future but we will not display it for now.
                        if(cell.textLabel?.text == userID) {
                            dispatch_async(dispatch_get_main_queue()) {
                                //cell.imageView?.image = avatarCircle
                                cell.imageView?.image = avatarSquare
                                
                            }
                        }
                    }
                    //}
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
