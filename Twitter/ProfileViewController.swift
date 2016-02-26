//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/26/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl)!)
                if let profileBackgroundImageUrl = user.profileBackgroundImageUrl {
                    backgroundImageView.setImageWithURL(NSURL(string: profileBackgroundImageUrl)!)
                }
                handleNameLabel.text = user.username
                userNameLabel.text = "@" + user.screenname
                userDescriptionLabel.text = user.userDescription
                numTweetsLabel.text = "\(user.numTweets)"
                numFollowingLabel.text = "\(user.numFollowing)"
                numFollowersLabel.text = "\(user.numFollowers)"
                
            }
        }
    }
    
    @IBAction func logoutTouchUpInside(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            user = User.currentUser
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshOnly", name: tweetDidPostNotification, object: nil)
        refreshOnly()
        // Do any additional setup after loading the view.
    }
    func refreshOnly() {
        TwitterClient.sharedInstance.userTimelineWithParams(User.currentUser!) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.userTimelineWithParams(User.currentUser!) { (tweets, error) -> () in
            print(error)
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as! TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TweetDetailViewController {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            vc.tweet = self.tweets![indexPath!.row]
        } else if let vc = segue.destinationViewController as? ComposeViewController {
            vc.replyToId = nil
            vc.replyToUserName = nil
        }
    }
}
