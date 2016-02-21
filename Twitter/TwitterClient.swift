//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
let twitterConsumerKey = "8a0fmHoQXA7GqzgWIgDA9SrJB"
let twitterConsumerSecret = "Bn07h4tTlD1I87D8kTwCyxo8CNHLK08l36UPpC3FHi5hpD2wba"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitter://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("hi")
            
            let authenticationURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authenticationURL!)
            
            }, failure: {(error: NSError!) -> Void in
                print (error)
                print ("hi2")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print(accessToken)
                self.requestSerializer.saveAccessToken(accessToken)
                self.GET("1.1/account/verify_credentials.json", parameters: nil,
                    progress: nil,
                    success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        let user = User(dict: response as! NSDictionary)
                        print(user)
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        self.loginCompletion?(user: nil, error: error)
                })
            },
            failure: { (error: NSError!) -> Void in
                print(error)
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                print(tweets)
                completion(tweets: tweets, error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweets: nil, error: error)
        })
    }
    
}
