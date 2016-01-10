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
    @IBOutlet weak var tipControl: UISegmentedControl!
    
 
    let defaults = NSUserDefaults.standardUserDefaults()
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    var keyboardHeight: CGFloat!
    var resultsDidShow: Bool = false
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("View did load!!!!!!!")
        self.navigationController?.navigationBar.translucent = false
        self.billView.backgroundColor = UIColor.magentaColor()
        
        self.resultsView.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.7)
  

        self.billField.delegate = self
        self.updateTipPercentageLabel()
        self.renderView()

}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
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
        print("Bill view did appear")
        self.calculateBill()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print ("keyboard showign")
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                keyboardHeight = keyboardSize.height
                // animate with stored value if animation has not happened yet
                if !self.resultsDidShow {
                    print("The keyboard is ready and aniimation has not happened yet")
                    
                    // update bill field with stored amount
                    let billAmount = self.getStoredBillAmount()
                    self.billField.text = billAmount
                    
                    if (billAmount.isEmpty) {
                        self.renderInputOnlyView()
                    } else {
                        self.renderResultsView()
                        print("Sliding animation up")
                    }
                    
                }
        
                
            }
        }
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        // only refresh if we've cleared out stored bill amount
        if (self.getStoredBillAmount().isEmpty) {
            self.renderView()
            
        }
    }
    
    func applicationDidEnterBackground(notification: NSNotification) {
        print("entered background so persisting")
        self.storeBillAmount()
    }
    func keyboardWillHide(notification: NSNotification) {
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
        // hide the tip amount
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
        print("User edited bill")
    
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
            
            // create a new frame where the height is half the current screen
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

