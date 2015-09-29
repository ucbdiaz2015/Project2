//
//  MediaTableViewCell.swift
//  Instagram
//
//  Created by ddd on 9/24/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var caption: UILabel!
    var userID : String!
    
    var post: InstaFeed.Post? {
        didSet {
            if let setPost = post {
                userID = setPost.userID
                
                likes.text = (setPost.likes as NSNumber).stringValue
                caption.text = (setPost.caption)
                
                
//                if let url = NSURL(string: setPost.postImageURL) {
//                    if let data = NSData(contentsOfURL: url) {
//                        postImage.contentMode = UIViewContentMode.ScaleAspectFit
//                        postImage.image = UIImage(data: data)
//                    }
//                }

                loadOrFetchImageFor(userID, postImageUrl: post!.postImageURL, cell: self)
                
            }
        }
    }
    
    var cachedImages = SwiftlyLRU<String, UIImage>(capacity: 15)
    

    
    func loadOrFetchImageFor(userID: String, postImageUrl: String, cell: MediaTableViewCell) -> Void {
        if let image = cachedImages[userID] { // already in cache
            cell.postImage?.image = image
        } else {
            if let url = NSURL(string: postImageUrl) { // need to fetch
                //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0))  {
                    if let data = NSData(contentsOfURL: url) {
                        if let avatarSquare = UIImage(data:data) {
                         //   let avatarCircle = UIImage.roundedRectImageFromImage(avatarSquare, imageSize: avatarSquare.size, cornerRadius: avatarSquare.size.width / 2)
                       //     self.cachedImages.updateValue(avatarCircle, forKey: login)
                            self.cachedImages[userID] = avatarSquare
                            // Because this happens asynchronously in the background, we need to check that by the time we get here
                            // that the cell that requested the image is still the one that is being displayed.
                            // If it is not, we would have cached the image for the future but we will not display it for now.
                            if(cell.userID == userID) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    //cell.imageView?.image = avatarCircle
                                    cell.postImage?.image = avatarSquare

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
