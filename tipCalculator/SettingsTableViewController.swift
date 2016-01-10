//
//  SettingsTableViewController.swift
//  tipCalculator
//
//  Created by Grace Wong on 1/8/16.
//  Copyright © 2016 gwongz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var defaultPercentageField: UITextField!
    @IBOutlet weak var maximumPercentageField: UITextField!
    @IBOutlet weak var minimumPercentageField: UITextField!
    @IBOutlet weak var displaySwitch: UISwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.initializeTextFields()
        self.initializeSwitch()

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
    
    func initializeSwitch() {
        let alwaysUseDefault = self.defaults.boolForKey(Constants.defaultDisplayKey)
        self.displaySwitch.setOn(alwaysUseDefault, animated: false)
    }
    
    func initializeTextFields() {
        self.defaultPercentageField.delegate = self
        self.defaultPercentageField.text = self.defaults.stringForKey(Constants.defaultPercentageKey)
        self.minimumPercentageField.text = self.defaults.stringForKey(Constants.minimumPercentageKey)
        self.maximumPercentageField.text = self.defaults.stringForKey(Constants.maximumPercentageKey)
        
    }
    
    func storePercentage(percentage: String, key: String) {
        self.defaults.setObject(percentage, forKey: key)
    }
    
    
    // MARK: Actions
    @IBAction func onDisplaySwitchChanged(sender: AnyObject) {
        self.defaults.setBool(self.displaySwitch.on, forKey: Constants.defaultDisplayKey)
    }

    @IBAction func onDefaultPercentageChanged(sender: AnyObject) {
        self.storePercentage(self.defaultPercentageField.text!, key: Constants.defaultPercentageKey)
    }
    
    @IBAction func onMinimumPercentageChanged(sender: AnyObject) {
        self.storePercentage(self.minimumPercentageField.text!, key: Constants.minimumPercentageKey)
    }
    
    @IBAction func onMaximumPercentageChanged(sender: AnyObject) {
        self.storePercentage(self.maximumPercentageField.text!, key: Constants.maximumPercentageKey)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}
