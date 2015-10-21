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
    @IBAction func onClickAdd(sender: UIButton) {
        print("Add!!!");
    }
    
    required init?(coder aDecoder: NSCoder) {
        _tmpSpendings = [NSDate: [Spending]]();
        _sortedSpendingDates = [NSDate]();
        _dateFormatter = NSDateFormatter();
        _dateFormatter.dateFormat = "dd-MM-yyyy";
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib.init(nibName: "TableViewTextView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "text_based");
        
        tableView.registerNib(UINib.init(nibName: "TableViewButtonView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "button_based");
        
//        let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier("button_based") as! TableViewButtonView;
//        footer.button.setTitle("add spending", forState: .Normal);
//        footer.button.addTarget(self, action: Selector("goToAdd"), forControlEvents: .TouchUpInside);
//        
//        var frame = footer.frame;
//        frame.size.height = 0;
//        footer.frame = frame;
//        
//        tableView.tableFooterView = footer;
        
        goToAdd();
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated);
//        if let height = tableView.tableFooterView?.frame.size.height {
//            tableView.contentInset = UIEdgeInsetsMake(0, 0, height + 200, 0);
//        }
//    }
    
    @IBAction func addedSpendingAndBack(segue: UIStoryboardSegue) {
        if segue.identifier == "add_and_back_to_list" {
            if let createdSpending = (segue.sourceViewController as? AddSpendingFormController)?.createdSpending {
                if _tmpSpendings[createdSpending.date!] == nil {
                    _tmpSpendings[createdSpending.date!] = [Spending]();
                }
                _tmpSpendings[createdSpending.date!]!.append(createdSpending);
                _sortedSpendingDates = Array(_tmpSpendings.keys).sort({ (aDate, bDate) -> Bool in
                    return aDate.compare(bDate) == .OrderedDescending;
                })
            }
        }
        print(_tmpSpendings);
        tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil);
        cell.textLabel!.text = "hello";
       
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
    
    func goToAdd(){
        performSegueWithIdentifier("add_new", sender: nil);
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
