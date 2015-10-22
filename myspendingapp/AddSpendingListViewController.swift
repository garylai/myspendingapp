//
//  AddSpendingListViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 14/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class AddSpendingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var _tmpSpendings : [NSDate: [Spending]]!;
    private var _sortedSpendingDates : [NSDate]!;
    private let _dateFormatter : NSDateFormatter;
    
    @IBOutlet weak var tableView: UITableView!
    
    var addedOrUpdatedSpending : Spending?;
    
    required init?(coder aDecoder: NSCoder) {
        _tmpSpendings = [NSDate: [Spending]]();
        _sortedSpendingDates = [NSDate]();
        _dateFormatter = NSDateFormatter();
        _dateFormatter.dateFormat = "dd-MM-yyyy";
        super.init(coder: aDecoder);
    }
    
    func editExisting(spending : Spending?) {
        performSegueWithIdentifier("edit_existing", sender: spending);
    }
    
    func goToAdd(){
        performSegueWithIdentifier("add_new", sender: self);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        addedOrUpdatedSpending = nil;
        if segue.identifier == "edit_existing" {
            if let destination = segue.destinationViewController as? AddSpendingFormController {
                destination.targetSpending = sender as? Spending;
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib.init(nibName: "TableViewTextView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "text_based");
        
        tableView.registerNib(UINib.init(nibName: "TableViewButtonView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "button_based");
        
        goToAdd();
    }
    
    private func createSortedDate() -> [NSDate]{
        return Array(_tmpSpendings.keys).sort({ (aDate, bDate) -> Bool in
            return aDate.compare(bDate) == .OrderedDescending;
        })
    }
    
    @IBAction func editedSpendingAndBack(segue: UIStoryboardSegue) {
        if let updatedSpending = addedOrUpdatedSpending ,
            let originalSpending = (segue.sourceViewController as? AddSpendingFormController)?.targetSpending {
                if updatedSpending.date != originalSpending.date {
                    if var arr = _tmpSpendings[originalSpending.date!],
                        let rowIndex = arr.indexOf(originalSpending){
                            arr.removeAtIndex(rowIndex);
                            if arr.count == 0 {
                                _tmpSpendings.removeValueForKey(originalSpending.date!);
                                _sortedSpendingDates = createSortedDate();
                            } else {
                                _tmpSpendings[originalSpending.date!] = arr;
                            }
                    }
                    
                    if _tmpSpendings[updatedSpending.date!] == nil {
                        _tmpSpendings[updatedSpending.date!] = [Spending]();
                        _sortedSpendingDates = createSortedDate();
                    }
                    _tmpSpendings[updatedSpending.date!]!.append(updatedSpending);
                } else {
                    originalSpending.value = updatedSpending.value;
                    originalSpending.spendingTypeId = updatedSpending.spendingTypeId;
                    originalSpending.note = updatedSpending.note;
                }
                tableView.reloadData();
        }
    }
    
    @IBAction func addedSpendingAndBack(segue: UIStoryboardSegue) {
        if let createdSpending = addedOrUpdatedSpending {
            if _tmpSpendings[createdSpending.date!] == nil {
                _tmpSpendings[createdSpending.date!] = [Spending]();
                _sortedSpendingDates = createSortedDate();
            }
            _tmpSpendings[createdSpending.date!]!.append(createdSpending);
        }
        tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - table view
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let date = _sortedSpendingDates[indexPath.section];
        let spending = _tmpSpendings[date]?[indexPath.row];
        editExisting(spending);
        return nil;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _tmpSpendings.keys.count + 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == _tmpSpendings.keys.count {
            return 0;
        }
        let date = _sortedSpendingDates[section];
        return _tmpSpendings[date]!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("spending_cell");
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "spending_cell");
        }
        let date = _sortedSpendingDates[indexPath.section];
        if let sp = _tmpSpendings[date]?[indexPath.row] {
            let note = (sp.note != nil ? ": \(sp.note!)" : "");
            let spt = Util.spendingTypesDict[sp.spendingTypeId!];
            
            cell.textLabel!.text = "\(sp.value!)";
            cell.detailTextLabel!.text = "\(spt!.name!)\(note)";
        }
       
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < _tmpSpendings.keys.count else {
            let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier("button_based") as! TableViewButtonView;
            footer.button.setTitle("add spending", forState: .Normal);
            footer.button.addTarget(self, action: Selector("goToAdd"), forControlEvents: .TouchUpInside);
            
            return footer;
        }
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("text_based") as! TableViewTextView;
        
        view.label.text = _dateFormatter.stringFromDate(_sortedSpendingDates[section]);
        
        return view;
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < _tmpSpendings.keys.count else {
            return nil;
        }
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("button_based") as! TableViewButtonView;
        
        let dateString = _dateFormatter.stringFromDate(_sortedSpendingDates[section]);
        view.button.setTitle("add more for \(dateString)", forState: .Normal);
        view.button.addTarget(self, action: Selector("goToAdd"), forControlEvents: .TouchUpInside);
        
        return view;
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteRow = UITableViewRowAction(style: .Default, title: "remove") { (rowAction, indexPath) -> Void in
            let date = self._sortedSpendingDates[indexPath.section];
            if var arr = self._tmpSpendings[date]{
                arr.removeAtIndex(indexPath.row);
                if arr.count == 0 {
                    self._tmpSpendings.removeValueForKey(date);
                    self._sortedSpendingDates = self.createSortedDate();
                    tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Left);
                } else {
                    self._tmpSpendings[date] = arr;
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left);
                }
            }
        }
        return [deleteRow];
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
