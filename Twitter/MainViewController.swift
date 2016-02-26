//
//  MainViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/25/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentsView: UIView!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuViewController.willMoveToParentViewController(self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }
    var contentsViewController: UIViewController! {
        didSet(oldContentViewController) {
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            view.layoutIfNeeded()
            contentsViewController.willMoveToParentViewController(self)
            contentsView.addSubview(contentsViewController.view)
            contentsViewController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.contentsViewLeadingContraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBOutlet weak var contentsViewLeadingContraint: NSLayoutConstraint!
    var originalLeadingConstraint: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        let velocity = sender.velocityInView(self.view)
        
        switch sender.state {
        case .Began:
            originalLeadingConstraint = contentsViewLeadingContraint.constant
            break
        case .Changed:
            if originalLeadingConstraint + translation.x >= 0 {
                contentsViewLeadingContraint.constant = originalLeadingConstraint + translation.x
            } else {
                contentsViewLeadingContraint.constant = 0
            }
        case .Ended:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.contentsViewLeadingContraint.constant = self.view.frame.size.width - 50
                } else {
                    self.contentsViewLeadingContraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        default:
            break
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
