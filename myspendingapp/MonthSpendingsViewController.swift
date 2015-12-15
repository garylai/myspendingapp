//
//  MonthSpendingsViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 10/12/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class MonthSpendingsViewController: UIViewController, UIToolbarDelegate {
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!
    private var _hairline :UIImageView?;
    @IBOutlet weak var s1: UIView!
    @IBOutlet weak var i1: UIView!
    @IBOutlet weak var s2: UIView!
    @IBOutlet weak var i2: UIView!
    @IBOutlet weak var s3: UIView!
    @IBOutlet weak var i3: UIView!
    @IBOutlet weak var s4: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for aView in (self.navigationController?.navigationBar.subviews)!  {
            for bView in aView.subviews{
                if bView.isKindOfClass(UIImageView) &&
                    bView.bounds.size.width == self.navigationController?.navigationBar.frame.size.width &&
                    bView.bounds.size.height < 2 {
                        _hairline = bView as? UIImageView;
                }
            }
        }
        
        let spacers = [s1,s2,s3,s4];
        let items = [i1,i2,i3];
        for index in 0..<spacers.count {
            let spacer = spacers[index];
            view.addConstraint(NSLayoutConstraint(item: spacer, attribute: .Top, relatedBy: .Equal, toItem: toolbar, attribute: .Bottom, multiplier: 1, constant: 0));
            view.addConstraint(NSLayoutConstraint(item: spacer, attribute: .Leading, relatedBy: .Equal, toItem: index == 0 ? view : items[index - 1], attribute: .Trailing, multiplier: 1, constant: 0));
            view.addConstraint(NSLayoutConstraint(item: spacer, attribute: .Trailing, relatedBy: .Equal, toItem: index == spacers.count-1 ? view : items[index], attribute: .Leading, multiplier: 1, constant: 0));
            if index + 1 < spacers.count{
                let widthConstraint = NSLayoutConstraint(item: spacer, attribute: .Width, relatedBy: .Equal, toItem: spacers[index + 1], attribute: .Width, multiplier: 1, constant: 0);
                widthConstraint.priority = 750;
                view.addConstraint(widthConstraint);
            }
        }
        for index in 0..<items.count {
            let item = items[index];
            view.addConstraint(NSLayoutConstraint(item: item, attribute: .Top, relatedBy: .Equal, toItem: toolbar, attribute: .Bottom, multiplier: 1, constant: 0));
            if index + 1 < items.count{
                view.addConstraint(NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: items[index + 1], attribute: .Width, multiplier: 1, constant: 0));
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        _hairline?.hidden = true;
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        _hairline?.hidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached;
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
