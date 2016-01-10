//
//  Tip.swift
//  tipCalculator
//
//  Created by Grace Wong on 1/7/16.
//  Copyright © 2016 gwongz. All rights reserved.
//

import Foundation

class Bill {
    // MARK: Properties
    var amount: Double
    var tipPercentage: Double?
    
    init(amount: Double, tipPercentage: String) {
        self.amount = amount
        self.tipPercentage = Double(tipPercentage)
    }
    var tipAmount: Double {
        get {
            return self.amount * (self.tipPercentage! / 100)
        }
    }
    
    var total: Double {
        get {
            return self.tipAmount + self.amount
        }
    }
}
