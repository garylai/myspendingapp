//
//  ViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 18/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit
import Alamofire
import MSAValidator
import ObjectMapper

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
    
    private var _loginValidator : Validator;
    private var _registerValidator : Validator;
    
    @IBOutlet weak var _lastNameContraint: NSLayoutConstraint!;
    
    @IBOutlet weak var _lastNameEmailContraint: NSLayoutConstraint!;
    @IBOutlet weak var _firstNameLastNameContraint: NSLayoutConstraint!;
    
    required init?(coder aDecoder: NSCoder) {
        _mode = .Login;
        _logInTextFields = [];
        _registerTextFields = [];
        _fieldOriginalHeight = 0;
        
        _loginValidator = Validator();
        _registerValidator = Validator();
        
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
        let (isValid, url, parameters) : (Bool, String, [String : String]) = {
            var url : String!;
            
            var (validFields, invalidFields) = _loginValidator.validate();
            var params = ["email": _emailTextField.text!, "password": _passwordTextField.text!]
            
            switch _mode {
            case .Register:
                url = "user";
                let registerValidationResult = _registerValidator.validate();
                validFields.appendContentsOf(registerValidationResult.valid);
                invalidFields.merge(registerValidationResult.invalid);
                params.merge(["first_name": _firstNameTextField.text!, "last_name": _lastNameTextField.text!]);
            case .Login:
                url = "user/token";
            }
            
            for tf in validFields {
                (tf as! MSATextField).isIncorrect = false;
            }
            
            for tf in invalidFields.keys {
                (tf as! MSATextField).isIncorrect = true;
            }
            
            return (invalidFields.count == 0, url, params);
        }();
        
        if isValid {
            Util.instance.mainController.showActivityIndicator = true;
            Util.instance.makeRequest(
                "POST",
                url,
                parameters: parameters,
                successCallback: { (json) -> Void in
                    if let loginInfo = Mapper<LogInInfo>().map(json) where loginInfo.mappingValid! {
                        print(loginInfo);
                        Util.instance.setLoginInfo(loginInfo);
                        Util.instance.mainController.changeSection(to: .AddSpending);
                    } else {
                        self.showErrorMessage();
                    }
                }, failedCallback: { (error, message) -> Void in
                    self.showErrorMessage(message);
                }, completedCallback: { () -> Void in
                    Util.instance.mainController.showActivityIndicator = false;
                }
            );
        }
    }
    
    private func showErrorMessage (message : String? = nil) {
        let title = { () -> String in
            switch _mode{
            case .Login:
                return "Login Failed";
            case .Register:
                return "Registration Failed";
            }
        }();
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK");
        alert.show();
    }
    
    private func setFieldsWithAnimation(animated : Bool = false){
        _firstNameTextField.isIncorrect = false;
        _lastNameTextField.isIncorrect = false;
        _emailTextField.isIncorrect = false;
        _passwordTextField.isIncorrect = false;
        
        _firstNameTextField.text = "";
        _lastNameTextField.text = "";
        _emailTextField.text = "";
        _passwordTextField.text = "";
        
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
            
        _loginValidator.makeSure(_emailTextField, IsPresent(), IsAnEmail());
        _loginValidator.makeSure(_passwordTextField, IsPresent());
        
        _registerValidator.makeSure(_firstNameTextField, IsPresent());
        _registerValidator.makeSure(_lastNameTextField, IsPresent());
        
        _logInTextFields.appendContentsOf([_emailTextField, _passwordTextField]);
        _registerTextFields.appendContentsOf([_firstNameTextField, _lastNameTextField, _emailTextField, _passwordTextField]);
        _firstNameTextField!.becomeFirstResponder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
}

