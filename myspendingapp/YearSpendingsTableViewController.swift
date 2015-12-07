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
    private var yearSpendingList : [YearSpending]?;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.instance.mainController.showActivityIndicator = true;
        let token = (Util.instance.getLoginInfo()?.token)!;
        Util.instance.makeRequest("GET", "spendings",
            customHeaders: ["Authorization": "Token token=\(token)"],
            successCallback: {
                (json : AnyObject?) -> Void in
                print(json);
                if let spendingList = Mapper<YearSpending>().mapArray(json) {
                    self.yearSpendingList = spendingList;
                    self.tableView.reloadData();
                }
            },
            failedCallback: {
                (apiError: APIError?, reason: String?) -> Void in
                print(apiError);
                print(reason);
                let alert = UIAlertView(title: "Get Spending Failed", message: reason, delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            },
            completedCallback: {
                () -> Void in
                Util.instance.mainController.showActivityIndicator = false;
            });
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selected-year" {
            if let targetController = segue.destinationViewController as? MonthSpendingsTableViewController {
                let selectedYearSpending = yearSpendingList![tableView.indexPathForSelectedRow!.row];
                targetController.targetYear = selectedYearSpending.yearOfSpending!;
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
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard yearSpendingList != nil else {
            return 0;
        }
        return yearSpendingList!.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("year-spending-cell", forIndexPath: indexPath)
        
        let target = yearSpendingList![indexPath.row];
        cell.textLabel?.text = "\(target.yearOfSpending!)";
        cell.detailTextLabel?.text = "\(target.total!)";

        return cell
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
