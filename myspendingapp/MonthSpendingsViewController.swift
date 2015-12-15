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
