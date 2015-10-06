//
//  MainViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 6/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var activityIndicatorContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var showActivityIndicator : Bool {
        get {
            return !activityIndicatorContainerView.hidden;
        }
        set (toShow){
            activityIndicatorContainerView.hidden = !toShow;
            if(toShow){
                self.view.bringSubviewToFront(activityIndicatorContainerView);
                activityIndicatorView.startAnimating();
            } 
        }
    }
    
    private let _loginStoryBoard : UIStoryboard;
    
    required init?(coder aDecoder: NSCoder) {
        _loginStoryBoard = UIStoryboard.init(name: "Login", bundle: nil);
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginController = _loginStoryBoard.instantiateInitialViewController()!
        self.addChildViewController(loginController);
        self.view.addSubview(loginController.view);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
