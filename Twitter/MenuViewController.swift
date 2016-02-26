//
//  MenuViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/25/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var timelineNavigationViewController: UIViewController!
    var profileNavigationViewController: UIViewController!
    var mentionsNavigationViewController: UIViewController!
    
    var navigationViewControllers = [UIViewController]()
    
    var mainViewController: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        timelineNavigationViewController = storyboard?.instantiateViewControllerWithIdentifier("TimelineNavigationViewController")
        profileNavigationViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        mentionsNavigationViewController = storyboard?.instantiateViewControllerWithIdentifier("MentionsNavigationViewController")
        navigationViewControllers.append(timelineNavigationViewController)
        navigationViewControllers.append(profileNavigationViewController)
        navigationViewControllers.append(mentionsNavigationViewController)
        
        mainViewController.contentsView.layoutIfNeeded()
        mainViewController.contentsViewController = timelineNavigationViewController
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell")!
        let items = ["Timeline", "Profile", "Mentions"]
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainViewController.contentsViewController = navigationViewControllers[indexPath.row]
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
