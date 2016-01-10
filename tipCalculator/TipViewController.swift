//
//  TipViewController.swift
//  tipCalculator
//
//  Created by Grace Wong on 1/6/16.
//  Copyright © 2016 gwongz. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
   
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!

    @IBOutlet weak var tipPercentageLabel: UILabel!
 
    let defaults = NSUserDefaults.standardUserDefaults()
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    var keyboardHeight: CGFloat!
    var resultsDidShow: Bool = false
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.translucent = false
        self.billView.backgroundColor = UIColor.magentaColor()
        self.resultsView.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.8)
  
        self.billField.delegate = self
        self.updateTipPercentageLabel()
        self.renderView()
}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillEnterForeground:"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidEnterBackground:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    
        self.billField.becomeFirstResponder()
        self.calculateBill()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.calculateBill()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.keyboardHeight = keyboardSize.height
                // show results with stored value if results not shown yet
                if !self.resultsDidShow {
                    let billAmount = self.getStoredBillAmount()
                    self.billField.text = billAmount
                    //                    let billAmount = self.billField.text!
                    if (billAmount.isEmpty) {
                        self.renderInputOnlyView()
                    } else {
                        self.renderResultsView()
                    }
                    
                }
            }
        }
    }

    func applicationWillEnterForeground(notification: NSNotification) {
        // only refresh if we've cleared out stored bill amount
        if (self.getStoredBillAmount().isEmpty) {
            self.renderView()
        } else {
            self.billField.text = self.getStoredBillAmount()
        }
    }
    
    func applicationDidEnterBackground(notification: NSNotification) {
        self.storeBillAmount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStoredBillAmount() -> String {
        if ((self.defaults.stringForKey(Constants.defaultBillAmountKey)) != nil) {
            return self.defaults.stringForKey(Constants.defaultBillAmountKey)!
        } else {
            return ""
        }
    }
    
    func renderView() {
        self.resultsDidShow = false
        if (self.getStoredBillAmount().isEmpty){
            self.renderInputOnlyView()
        }
    }
    
    func renderInputOnlyView() {
        // extend to full height without keyboard
        self.billView.frame = UIScreen.mainScreen().bounds
        
        // position the textfield in the frame
        self.billField.center = CGPointMake(CGRectGetWidth(self.billView.bounds) / 2.0, CGRectGetHeight(self.billView.bounds) / 3)
        self.tipPercentageLabel.center.y = CGRectGetHeight(self.billView.bounds) / 3 + CGFloat(self.billField.frame.height)
        self.tipPercentageLabel.hidden = true
        self.resultsView.hidden = true
       }
    
    func updateTipPercentageLabel() {
        let percentage = self.defaults.stringForKey(Constants.defaultPercentageKey)
        self.tipPercentageLabel.text = percentage
        self.tipPercentageLabel.text = self.tipPercentageLabel.text! + "%"
        self.tipPercentageLabel.hidden = !self.defaults.boolForKey(Constants.defaultDisplayKey)
    }
   
    func calculateBill() {
        // render the view with latest values
        guard let billAmount = Double(self.billField.text!) else {
            self.renderInputOnlyView()
            self.resultsDidShow = false
            return
        }
        let tipPercentage = self.defaults.stringForKey(Constants.defaultPercentageKey)
        let bill = Bill(amount: billAmount, tipPercentage: tipPercentage!)
        self.tipLabel.text = String(format: "$%.2f", bill.tipAmount)
        self.totalLabel.text = String(format: "$%.2f", bill.total)
        self.updateTipPercentageLabel()
    
        if !self.resultsDidShow {
            self.renderResultsView()
        }
        
    }
    
    
    func renderResultsView() {
        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: {
            let visibleFrameHeight = self.view.bounds.size.height - self.keyboardHeight
            let animatedBillHeight = visibleFrameHeight * 0.65
            let resultsViewHeight = visibleFrameHeight * 0.35
            self.resultsView.hidden = false
            
            // create new frame where the height is half the current screen
            self.billView.frame = CGRectMake(0, 0, self.view.frame.width, animatedBillHeight)
            
            // move the center up but offset by status bar height
            let billFieldOffset = self.billView.frame.height / 2 + self.statusBarHeight
            self.billField.center = CGPointMake(CGRectGetWidth(self.billView.frame) / 2, billFieldOffset)
            self.tipPercentageLabel.center.y -= self.billField.frame.height
            self.resultsView.frame = CGRectMake(0, self.billView.bounds.height, self.view.frame.width, resultsViewHeight)
            self.resultsDidShow = true
        }, completion: nil)
    }
    
    func storeBillAmount() {
        self.defaults.setObject(self.billField.text, forKey: Constants.defaultBillAmountKey)
    }
    
    
    // MARK: Actions

    @IBAction func onEditingChanged(sender: AnyObject) {
        self.calculateBill()
    }

}

