//
//  AddSpendingFormController.swift
//  myspendingapp
//
//  Created by GaryLai on 19/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit
import MSAValidator

class AddSpendingFormController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    private enum EditMode : Int {
        case None = 1
        case Date
        case Amount
        case Type
        case Note
    }
    
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var amountCell: UITableViewCell!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var typePickerCell: UITableViewCell!
    @IBOutlet weak var typePicker: UIPickerView!
    
    @IBOutlet weak var noteCell: UITableViewCell!
    @IBOutlet weak var noteTextView: UITextView!
    
    private var _validator : Validator!;
    private var _noteContent : String?;
    
    var createdSpending : Spending?;
    
    private var _editMode : EditMode {
        willSet(newValue) {
            tableView.beginUpdates();
            guard _editMode != newValue else {
                return;
            }
            
            switch _editMode {
            case .Date:
                dateTextField.textColor = UIColor.blackColor();
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(datePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Type:
                typeTextField.textColor = UIColor.blackColor();
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(typePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Amount:
                amountTextField.resignFirstResponder();
            case .Note:
                noteTextView.resignFirstResponder();
            case .None: ()
            }
        }
        didSet {
            guard _editMode != oldValue else {
                tableView.endUpdates();
                return;
            }
            switch _editMode {
            case .Date:
                dateTextField.textColor = UIColor.redColor();
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(datePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Type:
                typeTextField.textColor = UIColor.redColor();
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(typePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Amount:
                amountTextField.becomeFirstResponder();
            default: ()
            }
            tableView.endUpdates();
        }
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        let formater = NSDateFormatter();
        formater.locale = NSLocale(localeIdentifier: "en");
        formater.dateFormat = "dd-MMM-yyyy";
        dateTextField.text = formater.stringFromDate(sender.date);
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeTextField.text = "";
        } else {
            let option = Util.spendingTypes[row - 1];
            typeTextField.text = option.name;
        }
        validateForm();
    }
    
    private var cellArrangement : (order: [UITableViewCell], height: [CGFloat]) {
        get{
            switch _editMode{
            case .Date:
                return ([dateCell, datePickerCell, amountCell, typeCell, noteCell], [44, 200, 44, 44, 200]);
            case .Type:
                return ([dateCell, amountCell, typeCell, typePickerCell, noteCell], [44, 44, 44, 150, 200]);
            default:
                return ([dateCell, amountCell, typeCell, noteCell], [44, 44, 44, 200]);
            }
        }
    }
    
    func onDone() {
        let calendar = NSCalendar.currentCalendar();
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0);
        let compenents = calendar.components([.Month, .Day, .Year], fromDate: datePicker.date);
        
        createdSpending = Spending();
        createdSpending!.spendingTypeId = Util.spendingTypes[typePicker.selectedRowInComponent(0)].id;
        createdSpending!.value = Float(amountTextField.text!);
        createdSpending!.date = calendar.dateFromComponents(compenents);
        createdSpending!.note = _noteContent;
        self.performSegueWithIdentifier("add_and_back_to_list", sender: self);
    }
    
    func validateForm() {
        self.navigationItem.rightBarButtonItem?.enabled = _validator.validate().invalid.count == 0;
    }
    
    required init?(coder aDecoder: NSCoder) {
        _editMode = .None;
        _validator = Validator();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Spending";
        self.datePickerValueChanged(datePicker);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "onDone");
        self.navigationItem.rightBarButtonItem?.enabled = false;
        
        _validator.register(amountTextField, withName: "value", forRules: RequiredRule());
        _validator.register(typeTextField, withName: "spending_type", forRules: RequiredRule());
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let heights = cellArrangement.height;
        return heights[indexPath.row];
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let targetCell = cellArrangement.order[indexPath.row];
        switch targetCell {
        case dateCell:
            _editMode = .Date;
        case typeCell:
            _editMode = .Type;
        case amountCell:
            _editMode = .Amount;
        case noteCell:
            _editMode = .Note;
        default:
            _editMode = .None;
        }
        return nil;
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        _editMode = .None;
    }
    
    // MARK: - Text Field Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string);
        validateForm();
        return false;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        _editMode = .Amount;
        return true;
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        _editMode = .Note;
        if _noteContent == nil || _noteContent!.isEmpty {
            noteTextView.text = "";
            noteTextView.textColor = UIColor.blackColor();
        }
        return true;
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        _noteContent = noteTextView.text;
        if _noteContent == nil || _noteContent!.isEmpty{
            noteTextView.text = "Note";
            noteTextView.textColor = UIColor.lightGrayColor();
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cellArrangement.order.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cellArrangement.order[indexPath.row];
    }
    
    // MARK: - Picker View
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Util.spendingTypes.count + 1;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row > 0 else {
            return "<Please select>";
        }
        let spendingType = Util.spendingTypes[row - 1];
        return spendingType.name;
    }
}
