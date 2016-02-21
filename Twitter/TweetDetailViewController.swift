//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            print(self.profileImageView)
            profileImageView.setImageWithURL(NSURL(string: tweet.user.profileImageUrl)!)
            handleNameLabel.text = tweet.user.username
            userNameLabel.text = "@" + tweet.user.screenname
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "YYYY-MM-dd HH:mm:SS"
            createdTimeLabel.text = formatter.stringFromDate(tweet.createdAt)
            tweetTextLabel.text = tweet.text
            
            favoritesCountLabel.text = String(tweet.favoritesCount)
            retweetCountLabel.text = String(tweet.retweetCount)
            
            if tweet.retweeted {
                retweetImageView.image = UIImage(named: "retweet-action-on")
            } else {
                retweetImageView.image = UIImage(named: "retweet-action")
            }
            if tweet.favorited {
                favoriteImageView.image = UIImage(named: "like-action-on")
            } else {
                favoriteImageView.image = UIImage(named: "like-action")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
