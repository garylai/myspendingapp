//
//  ViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 18/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    private enum Mode : Int{
        case Login = 1
        case Register
    }
    
    private let LOGIN_TEXT : String = "Log In";
    private let REGISTER_TEXT : String = "Join";
    
    private var _mode : Mode;
    @IBOutlet weak var _firstNameTextField: MSATextField!;
    @IBOutlet weak var _lastNameTextField: MSATextField!;
    @IBOutlet weak var _emailTextField: MSATextField!;
    @IBOutlet weak var _passwordTextField: MSATextField!;
    @IBOutlet weak var _changeModeBtn: UIButton!;
    
    private var _logInTextFields : [MSATextField];
    private var _registerTextFields : [MSATextField];
    
    private var _fieldOriginalHeight : CGFloat;
    private let _fieldsMargin : CGFloat = 5;
    
    @IBOutlet weak var _lastNameContraint: NSLayoutConstraint!;
    
    @IBOutlet weak var _lastNameEmailContraint: NSLayoutConstraint!;
    @IBOutlet weak var _firstNameLastNameContraint: NSLayoutConstraint!;
    
    required init?(coder aDecoder: NSCoder) {
        _mode = .Login;
        _logInTextFields = [];
        _registerTextFields = [];
        _fieldOriginalHeight = 0;
        super.init(coder: aDecoder);
    }
    
    @IBAction func onChangeMode(sender: AnyObject) {
        _mode = (_mode == .Login ? .Register : .Login);
        setFieldsWithAnimation(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let targetArr = (_mode == .Login ? _logInTextFields : _registerTextFields);
        let idx = targetArr.indexOf(textField as! MSATextField);
        
        assert(idx != nil);
        
        if(idx! < targetArr.count - 1){
            targetArr[idx! + 1].becomeFirstResponder();
            textField.resignFirstResponder();
        } else {
            onDone();
        }
        return false;
    }
    
    @IBAction func onDone() {
        print("done!");
    }
    
    private func setFieldsWithAnimation(animated : Bool = false){
        var targetTF : MSATextField!;
        var targetAlpha : CGFloat!;
        var targetHeight : CGFloat!;
        var titleText : String!;
        var btnText : String!;
        var margin: CGFloat!;
        
        switch(_mode) {
        case .Login:
            targetHeight = 0;
            targetAlpha = 0;
            targetTF = _emailTextField;
            titleText = LOGIN_TEXT;
            btnText = REGISTER_TEXT;
            margin = 0;
        case .Register:
            targetHeight = _fieldOriginalHeight;
            targetAlpha = 1;
            targetTF = _firstNameTextField;
            titleText = REGISTER_TEXT;
            btnText = LOGIN_TEXT;
            margin = _fieldsMargin;
        }
        
        func valuesSetup() {
            self._lastNameContraint.constant = targetHeight;
            self._firstNameTextField.alpha = targetAlpha;
            self._lastNameTextField.alpha = targetAlpha;
            self._firstNameLastNameContraint.constant = margin;
            self._lastNameEmailContraint.constant = margin;
        }
        
        func completion() {
            targetTF.becomeFirstResponder();
            self.title = titleText;
            self._changeModeBtn.setTitle(btnText, forState: UIControlState.Normal);
            self._changeModeBtn.setTitle(btnText, forState: UIControlState.Highlighted);
        }
        
        if(animated){
            self.view.layoutIfNeeded();
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                valuesSetup();
                self.view.layoutIfNeeded();
                }, completion: { (completed) -> Void in
                    completion();
            });
        } else {
            valuesSetup();
            completion();
            self.view.layoutIfNeeded();
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        _fieldOriginalHeight = _emailTextField.frame.height;
        _lastNameContraint.constant = _fieldOriginalHeight;
        setFieldsWithAnimation();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        _logInTextFields.appendContentsOf([_emailTextField, _passwordTextField]);
        _registerTextFields.appendContentsOf([_firstNameTextField, _lastNameTextField, _emailTextField, _passwordTextField]);
        _firstNameTextField!.becomeFirstResponder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
}

