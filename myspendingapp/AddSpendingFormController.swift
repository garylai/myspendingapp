//
//  AddSpendingFormController.swift
//  myspendingapp
//
//  Created by GaryLai on 19/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class AddSpendingFormController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    private enum EditMode : Int {
        case None = 1
        case Date
        case Type
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
    
    private var cellArrangement : (order: [UITableViewCell], height: [CGFloat]) {
        get{
            switch _editMode{
            case .None:
                return ([dateCell, amountCell, typeCell, noteCell], [44, 44, 44, 200]);
            case .Date:
                return ([dateCell, datePickerCell, amountCell, typeCell, noteCell], [44, 200, 44, 44, 200]);
            case .Type:
                return ([dateCell, amountCell, typeCell, typePickerCell, noteCell], [44, 44, 44, 200, 200]);
            }
        }
    }
    
    private var _editMode : EditMode {
        willSet(newValue) {
            tableView.beginUpdates();
            guard _editMode != newValue else {
                return;
            }
            
            switch _editMode {
            case .Date:
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(datePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Type:
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(typePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .None:
                amountTextField.resignFirstResponder();
                noteTextView.resignFirstResponder();
            }
        }
        didSet {
            guard _editMode != oldValue else {
                tableView.endUpdates();
                return;
            }
            switch _editMode {
            case .Date:
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(datePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            case .Type:
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.cellArrangement.order.indexOf(typePickerCell)!, inSection: 0)], withRowAnimation: .Fade);
            default: ()
            }
            tableView.endUpdates();
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        _editMode = .None;
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Spending";
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        setModeByIndexPath(indexPath);
        return nil;
    }
    
    private func setModeByIndexPath(indexPath: NSIndexPath) {
        let targetCell = cellArrangement.order[indexPath.row];
        switch targetCell {
        case dateCell:
            _editMode = .Date;
        case typeCell:
            _editMode = .Type;
        default:
            _editMode = .None;
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        _editMode = .None;
        return true;
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        _editMode = .None;
        return true;
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
        return Util.spendingTypes.count;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let spendingType = Util.spendingTypes[row];
        return spendingType.name;
    }
}
