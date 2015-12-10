//
//  MainViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 6/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit
import ObjectMapper

enum AppSection {
    case None
    case LogIn
    case AddSpending
    case ListSpendings
}

class MainViewController: UIViewController {
    private var _currentSection : AppSection;
    private var _currentViewController : UIViewController?;
    
    private let _activityIndicatorViewController : ActivityIndicatorViewController!;
    private let _activityViewWindow : UIWindow!;
    
    var showActivityIndicator : Bool {
        get {
            return !_activityViewWindow.hidden;
        }
        set (toShow){
            _activityViewWindow.hidden = !toShow;
            if(toShow){
                _activityIndicatorViewController.activityIndicator.startAnimating();
            } 
        }
    }
    
    func changeSection(to toSection : AppSection) {
        let fromSection = _currentSection;
        let currentViewController = _currentViewController;
        
        var targetViewController : UIViewController?;
        
        switch toSection {
        case .None:
            break;
        case .LogIn:
            let loginStoryBoard = UIStoryboard.init(name: "Login", bundle: nil);
            targetViewController = loginStoryBoard.instantiateInitialViewController();
        case .AddSpending:
            let addSpendingStoryBoard = UIStoryboard.init(name: "AddSpending", bundle: nil);
            targetViewController = addSpendingStoryBoard.instantiateInitialViewController();
        case .ListSpendings:
            let listSpeindingsStoryBoard = UIStoryboard.init(name: "SpendingList", bundle: nil);
            targetViewController = listSpeindingsStoryBoard.instantiateInitialViewController();
        }
        
        if let c = targetViewController {
            self.addChildViewController(c);
            self.view.addSubview(c.view);
        }
        
        _currentSection = toSection;
        _currentViewController = targetViewController;
        
        switch fromSection {
        case .None:
            break;
        default:
            if let c = currentViewController {
                c.removeFromParentViewController();
                c.view.removeFromSuperview();
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        _currentSection = .None;
        
        _activityIndicatorViewController = ActivityIndicatorViewController();
        _activityIndicatorViewController.view.frame = UIScreen.mainScreen().bounds;
        
        _activityViewWindow = UIWindow();
        _activityViewWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _activityViewWindow.frame = UIScreen.mainScreen().bounds;
        _activityViewWindow.backgroundColor = UIColor.clearColor();
        _activityViewWindow.addSubview(_activityIndicatorViewController.view);
        _activityViewWindow.rootViewController = _activityIndicatorViewController;
        super.init(coder: aDecoder);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        guard Util.instance.loadSpendingType() else {
            exit(0);
        }
        
//        Util.deleteLoginInfo();
        if let loginInfo = Util.instance.getLoginInfo() {
            print("has loging_info id: \(loginInfo.id)");
            print("             token: \(loginInfo.token)");
            //            Util.deleteLoginInfo();
            changeSection(to: .ListSpendings);
        } else {
            changeSection(to: .LogIn);
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
