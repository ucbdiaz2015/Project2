//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by ddd on 9/27/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    
    
    
    
    var commentInfo: InstaFeed.Comment? {
        didSet {
            if let setComment = commentInfo {
                username.text = setComment.username
                comment.text = setComment.text
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
