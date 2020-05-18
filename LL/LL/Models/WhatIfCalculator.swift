//
//  WhatIfCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/17/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

class WhatIfCalculator{
    var principal: Double
    var interestRate: Double
    var months: Int
    var monthlyInterestRate: Double = 0
    
    
    init (principal: Double, interestRate: Double, months: Int) {
        self.principal = principal
        self.interestRate = interestRate
        self.months = months
        self.monthlyInterestRate = (interestRate / 100) / 12
    }
    
    func mortgageMonthly() -> Double {
        let power = Double(truncating: pow((Decimal)(1 + self.monthlyInterestRate), self.months) as NSNumber)
        let numerator = self.principal * (self.monthlyInterestRate * power)
        let denominator = power - 1

        let roundedMonthly = ((numerator / denominator) * 100).rounded() / 100
    
        return roundedMonthly
    }
    
    func totalInterest() -> Double {
        var balanceArray: [Double] = []
        var totalInterest: Double = 0
        let powerNMonths = Double(truncating: pow((Decimal)(1 + monthlyInterestRate), self.months) as NSNumber)
        
        for index in 0...(self.months) {
            let powerPMonths = Double(truncating: pow((Decimal)(1 + monthlyInterestRate), index) as NSNumber)
            let numerator2 = self.principal * (powerNMonths - powerPMonths)
            let denominator2 = powerNMonths - 1
            balanceArray.append(((numerator2 / denominator2) * 100).rounded() / 100)
        }
        
        for balance in balanceArray{
            totalInterest += (((self.monthlyInterestRate * balance) * 100).rounded() / 100)
        }
        return totalInterest
    }
}
