//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var replyToId: String?
    var replyToUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNameLabel.text = User.currentUser!.username
        userNameLabel.text = "@" + User.currentUser!.screenname
        if replyToId != nil && replyToUserName != nil {
            textView.text = "@\(replyToUserName!)"
        } else {
            textView.text = ""
        }
        profileImageView.setImageWithURL(NSURL(string: (User.currentUser!.profileImageUrl))!)
        // Do any additional setup after loading the view.
        
        textView.delegate = self
    }

    func textViewDidChange(textView: UITextView) {
        let len = (textView.text as NSString).length
        charCountLabel.text = String(140 - len)
        if 140 - len >= 0 {
            charCountLabel.textColor = UIColor.grayColor()
        } else {
            charCountLabel.textColor = UIColor.redColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }

    @IBAction func onSend(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.postTweet(textView.text, inReplyTo: self.replyToId) { (error) -> () in
            if let navigationController = self.navigationController {
                navigationController.popViewControllerAnimated(true)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
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
