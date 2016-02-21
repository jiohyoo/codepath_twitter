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
    @IBOutlet weak var replyImageView: UIImageView!
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
            replyImageView.image = UIImage(named: "reply-action")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetTap(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.retweeted {
                TwitterClient.sharedInstance.unretweet(tweet.id, completion: { (error) -> () in
                })
                tweet.retweetCount -= 1
                tweet.retweeted  = false
            } else {
                TwitterClient.sharedInstance.retweet(tweet.id, completion: { (error) -> () in
                })
                tweet.retweetCount += 1
                tweet.retweeted  = true
            }

            if tweet.retweeted {
                retweetImageView.image = UIImage(named: "retweet-action-on")
            } else {
                retweetImageView.image = UIImage(named: "retweet-action")
            }
            retweetCountLabel.text = String(tweet.retweetCount)
        }
    }
    
    @IBAction func onFavoriteTap(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.favorited {
                TwitterClient.sharedInstance.unfavorite(tweet.id, completion: { (error) -> () in
                })
                tweet.favoritesCount -= 1
                tweet.favorited  = false
            } else {
                TwitterClient.sharedInstance.favorite(tweet.id, completion: { (error) -> () in
                })
                tweet.favoritesCount += 1
                tweet.favorited  = true
            }
            
            if tweet.favorited {
                favoriteImageView.image = UIImage(named: "like-action-on")
            } else {
                favoriteImageView.image = UIImage(named: "like-action")
            }
            favoritesCountLabel.text = String(tweet.favoritesCount)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ComposeViewController {
            vc.replyToId = tweet?.id
            vc.replyToUserName = tweet?.user.screenname
        }
    }

}
