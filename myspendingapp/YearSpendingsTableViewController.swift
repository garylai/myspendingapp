//
//  YearSpendingsTableViewController.swift
//  myspendingapp
//
//  Created by GaryLai on 7/12/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit
import ObjectMapper

class YearSpendingsTableViewController: UITableViewController {
    private var yearSpendingList : [String: [YearSpending]]?;
    private var sortedYears : [Int]?;
    
    func refreshData() {
        Util.instance.mainController.showActivityIndicator = true;
        let token = (Util.instance.getLoginInfo()?.token)!;
        Util.instance.makeRequest("GET", "spendings",
            customHeaders: ["Authorization": "Token token=\(token)"],
            successCallback: {
                (json : AnyObject?) -> Void in
                if let spendingList = Mapper<YearSpending>().mapDictionaryOfArrays(json) {
                    self.yearSpendingList = spendingList;
                    self.sortedYears = Array(spendingList.keys).map({ (key) -> Int in
                        return Int(key)!;
                    }).sort().reverse();
                    self.tableView.reloadData();
                }
            },
            failedCallback: {
                (apiError: APIError?, reason: String?) -> Void in
                let alert = UIAlertView(title: "Get Spending Failed", message: reason, delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            },
            completedCallback: {
                () -> Void in
                Util.instance.mainController.showActivityIndicator = false;
                self.refreshControl?.endRefreshing();
        });
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        
        refreshControl = UIRefreshControl();
        refreshControl?.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged);
        
        refreshData();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selected-year" {
            if let targetController = segue.destinationViewController as? MonthSpendingsTableViewController {
                let selectedYearSpending = sortedYears![tableView.indexPathForSelectedRow!.section];
                targetController.targetYear = selectedYearSpending;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard yearSpendingList != nil else {
            return 0;
        }
        return yearSpendingList!.count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = String(sortedYears![section]);
        guard yearSpendingList![key] != nil else {
            return 0;
        }
        
        let count = Float(yearSpendingList![key]!.count);
        return Int(ceil(count/2.0));
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = String(sortedYears![section]);
        return key;
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let key = String(sortedYears![section]);
        let spendings = yearSpendingList![key]!;
        var total = Float(0);
        for s in spendings {
            total = total + s.total!;
        }
        return "total: \(total)";
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("year-spending-cell", forIndexPath: indexPath) as! TypeSpendingCell;
        cell.selectionStyle = .None;
        
        let key = String(sortedYears![indexPath.section]);
        let spendings = yearSpendingList![key]!;
        let spendingLeft = spendings[2 * indexPath.row];
        let spendingRight : YearSpending? = {
            if (2 * indexPath.row + 1) < spendings.count {
               return spendings[2 * indexPath.row + 1];
            }
            return nil;
        }();
        
        let spendingTypes = Util.instance.spendingTypesDict;
        let leftName = spendingTypes[spendingLeft.spendingTypeId!]?.name;
        cell.leftTypeLabel.text = "\(leftName!)";
        cell.leftValue.text = "\(spendingLeft.total!)";
        if spendingRight != nil {
            let rightName = spendingTypes[spendingRight!.spendingTypeId!]?.name;
            cell.rightTypeLabel.text = "\(rightName!)";
            cell.rightValue.text = "\(spendingRight!.total!)";
            cell.rightView.hidden = false;
        } else {
            cell.rightView.hidden = true;
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
