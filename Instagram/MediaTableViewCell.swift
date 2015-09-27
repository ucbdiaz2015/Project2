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
    
    
    
    
    var post: InstaFeed.Post? {
        didSet {
            if let setPost = post {
                likes.text = (setPost.likes as NSNumber).stringValue
                caption.text = setPost.caption
                
                
                if let url = NSURL(string: setPost.profilePicURL) {
                    if let data = NSData(contentsOfURL: url) {
                        self.postImage.contentMode = UIViewContentMode.ScaleAspectFit
                        self.postImage.image = UIImage(data: data)
                    } else {
                        self.postImage.image = UIImage(named: "world")
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
