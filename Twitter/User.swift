//
//  User.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUserKey"

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
class User: NSObject {
    var dict: NSDictionary

    var id: String
    var username: String
    var screenname: String
    var profileImageUrl: String
    var userDescription: String
    var profileBackgroundImageUrl: String?
    var numFollowing: Int
    var numFollowers: Int
    var numTweets: Int
    
    init(dict: NSDictionary) {
        self.dict = dict
        id = dict["id_str"] as! String
        username = dict["name"] as! String
        screenname = dict["screen_name"] as! String
        profileImageUrl = dict["profile_image_url"] as! String
        userDescription = dict["description"] as! String
        profileBackgroundImageUrl = dict["profile_background_image_url"] as? String ?? nil
        numFollowing = dict["friends_count"] as! Int
        numFollowers = dict["followers_count"] as! Int
        numTweets = dict["statuses_count"] as! Int
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if let data = data {
                    do {
                        if let dict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                            _currentUser = User(dict: dict)
                        }
                    } catch {
                        print("Deserializing user failed")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            var data: NSData? = nil
            if let user = user {
                do {
                    data = try NSJSONSerialization.dataWithJSONObject(user.dict, options: []) as NSData
                    print(data)
                } catch {
                    print("Persisting user failed")
                }
            }
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
