//
//  ViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 18/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    private enum Mode : Int{
        case Login = 1
        case Register
    }
    
    private let LOGIN_TEXT : String = "Log In";
    private let REGISTER_TEXT : String = "Register";
    
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
        
        if let email = _emailTextField.text, let password = _passwordTextField.text {
            let parameters = ["email": email, "password": password];
            let url = "\(ENV.APIURLPrefix)/user/token";
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
                .responseJSON { _, response, result in
                    if let statusCode = response?.statusCode {
                        if (200..<300).contains(statusCode) {
                            print("succeed with : \(result.value)");
                        } else {
                            // pop message
                            print("failed with : \(result.value)");
                        }
                    } else {
                        // pop message
                        print("failed with: \(result.error)");
                    }
                    print("completed");
            }
        }
    }
    
    private func setFieldsWithAnimation(animated : Bool = false){
        
        func valuesSetup() {
            self._lastNameContraint.constant = (_mode == .Login ? 0 : _fieldOriginalHeight);
            self._firstNameTextField.alpha = (_mode == .Login ? 0 : 1);
            self._lastNameTextField.alpha = (_mode == .Login ? 0 : 1);
            self._firstNameLastNameContraint.constant = (_mode == .Login ? 0 : _fieldsMargin);
            self._lastNameEmailContraint.constant = (_mode == .Login ? 0 : _fieldsMargin);
        }
        
        func completion() {
            let targetTF : MSATextField = (_mode == .Login ? _emailTextField : _firstNameTextField);
            targetTF.becomeFirstResponder();
            
            self.title = (_mode == .Login ? LOGIN_TEXT : REGISTER_TEXT);
            self._changeModeBtn.setTitle((_mode == .Login ? REGISTER_TEXT : LOGIN_TEXT),
                                            forState: UIControlState.Normal);
            self._changeModeBtn.setTitle((_mode == .Login ? REGISTER_TEXT : LOGIN_TEXT),
                                            forState: UIControlState.Highlighted);
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

