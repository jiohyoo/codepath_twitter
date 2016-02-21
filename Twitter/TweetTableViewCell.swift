//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                profileImageView.setImageWithURL(NSURL(string: tweet.user.profileImageUrl)!)
                handleNameLabel.text = tweet.user.username
                userNameLabel.text = "@" + tweet.user.screenname
                let interval: Int = Int(NSDate().timeIntervalSinceDate(tweet.createdAt))
                createdTimeLabel.text = makeCreatedTimeLabelText(interval)
                tweetTextLabel.text = tweet.text
            }
        }
    }
    
    func makeCreatedTimeLabelText(val: Int) -> String {
        if val < 60 {
            return "\(val)s"
        } else if val < 3600 {
            return "\(val / 60)m"
        } else { //if val < 86400 {
            return "\(val / 3600)h"
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
