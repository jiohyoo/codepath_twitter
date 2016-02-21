//
//  Tweet.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User
    var text: String
    var createdAtString: String
    var createdAt: NSDate
    var dict: NSDictionary
    var retweeted: Bool
    var favorited: Bool
    var retweetCount: Int
    var favoritesCount: Int
    
    init(dict: NSDictionary) {
        print(dict)
        self.dict = dict
        user = User(dict: dict["user"] as! NSDictionary)
        text = dict["text"] as! String
        createdAtString = dict["created_at"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString)!
        retweeted = dict["retweeted"] as! Bool
        retweetCount = dict["retweet_count"] as! Int
        favorited = dict["favorited"] as! Bool
        favoritesCount = dict["favorite_count"] as! Int        
    }
    
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dict: dict))
        }
        
        return tweets
    }
}
