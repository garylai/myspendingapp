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
    private enum EditingField : Int {
        case None = 1
        case Date
        case Amount
        case Type
        case Note
    }
    
    private enum Mode : Int {
        case Editing = 1
        case Adding
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
    private var _noteContent : String!;
    
    var targetSpending : Spending?;
    var targetDate: NSDate?;
    
    private var _mode : Mode?;
    
    private var _editingField : EditingField {
        willSet(newValue) {
            tableView.beginUpdates();
            guard _editingField != newValue else {
                return;
            }
            
            switch _editingField {
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
            guard _editingField != oldValue else {
                tableView.endUpdates();
                return;
            }
            switch _editingField {
            case .Date:
                dateTextField.textColor = self.view.tintColor;
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(datePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Type:
                typeTextField.textColor = self.view.tintColor;
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(typePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Amount:
                amountTextField.becomeFirstResponder();
            default: ()
            }
            tableView.endUpdates();
            validateForm();
        }
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        let formater = NSDateFormatter();
        formater.locale = NSLocale(localeIdentifier: "en");
        formater.dateFormat = "dd-MMM-yyyy";
        dateTextField.text = formater.stringFromDate(sender.date);
    }
    
    private var cellArrangement : (order: [UITableViewCell], height: [CGFloat]) {
        get{
            switch _editingField{
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
        _editingField = .None;
        
        let calendar = NSCalendar.currentCalendar();
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0);
        let compenents = calendar.components([.Month, .Day, .Year], fromDate: datePicker.date);
        
        let resultSpending = Spending();
        var targetSegueId = "edited_and_back_to_list";
        if _mode == .Adding {
            targetSegueId = "add_and_back_to_list";
        }
        resultSpending.spendingTypeId = Util.spendingTypes[typePicker.selectedRowInComponent(0) - 1].id;
        resultSpending.value = Float(amountTextField.text!);
        resultSpending.date = calendar.dateFromComponents(compenents);
        resultSpending.note = _noteContent;
        
        self.performSegueWithIdentifier(targetSegueId, sender: resultSpending);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? AddSpendingListViewController {
            destination.addedOrUpdatedSpending = sender as? Spending;
        }
    }
    
    func validateForm() {
        let (_, invalidFields) = _validator.validate();
        self.navigationItem.rightBarButtonItem?.enabled = invalidFields.count == 0;
    }
    
    required init?(coder aDecoder: NSCoder) {
        _editingField = .None;
        _validator = Validator();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var barBtnTitle : String;
        if let spending = targetSpending,
            let date = spending.date,
            let value = spending.value,
            let index = Util.spendingTypes.indexOf({ (spt) -> Bool in
                return spt.id == spending.spendingTypeId;
            }){
                datePicker.date = date;
                amountTextField.text = "\(value)";
                
                typePicker.selectRow(index + 1, inComponent: 0, animated: false);
                self.pickerView(typePicker, didSelectRow: index + 1, inComponent: 0);
                
                self.textViewShouldBeginEditing(noteTextView);
                noteTextView.text = spending.note;
                self.textViewDidEndEditing(noteTextView);
                
                _mode = .Editing;
                barBtnTitle = "Update";
        } else if let date = targetDate {
            datePicker.date = date;
            _mode = .Adding;
            barBtnTitle = "Add";
        } else {
            _mode = .Adding;
            barBtnTitle = "Add";
        }
        
        self.navigationItem.title = "Add Spending";
        self.datePickerValueChanged(datePicker);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: barBtnTitle, style: .Done, target: self, action: "onDone");
        self.navigationItem.rightBarButtonItem?.enabled = false;
        
        _validator.makeSure(amountTextField, IsPresent());
        _validator.makeSure(typePicker, Component(0, IsInRange: 1...Util.spendingTypes.count));
        _validator.makeSure(noteTextView, IsShorterThan(Spending.NOTE_MAX_LENGTH));
        
        validateForm();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Text Field Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let newText = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string){
            if newText.isEmpty {
                textField.text = ""
            } else if let _ = Float(newText) {
                textField.text = newText;
            }
            validateForm();
        }
        return false;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text,
            let newValue = Float(text) {
            textField.text = "\(newValue)";
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        _editingField = .Amount;
        return true;
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if let newText = (textView.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: text){
            if newText.characters.count > Spending.NOTE_MAX_LENGTH {
                textView.textColor = UIColor.redColor();
            } else {
                textView.textColor = UIColor.blackColor();
            }
            textView.text = newText;
            validateForm();
        }
        return false;
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        _editingField = .Note;
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

    // MARK: - Table view data source & delegate
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let heights = cellArrangement.height;
        return heights[indexPath.row];
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let targetCell = cellArrangement.order[indexPath.row];
        let targetEditingField : EditingField;
        switch targetCell {
        case dateCell:
            targetEditingField = .Date;
        case typeCell:
            targetEditingField = .Type;
        case amountCell:
            targetEditingField = .Amount;
        case noteCell:
            targetEditingField = .Note;
        default:
            targetEditingField = .None;
        }
        
        _editingField = targetEditingField == _editingField ? .None : targetEditingField;
        return nil;
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        _editingField = .None;
    }

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
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeTextField.text = "";
        } else {
            let option = Util.spendingTypes[row - 1];
            typeTextField.text = option.name;
        }
        validateForm();
    }
}
