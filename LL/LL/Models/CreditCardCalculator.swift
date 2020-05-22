//
//  CreditCardCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/21/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

class CreditCardCalculator {
    var creditCardBalance: Double
    var interest: Double
    var term: Int
    var monthlyPayments: Double
    var monthlyInterestRate: Double
    let monthInYear: Double = 12
    let percentConvertor: Double = 100
    
    init(creditCardBalance: Double, interest: Double, term: Int, monthlyPayments: Double) {
        self.creditCardBalance = creditCardBalance
        self.interest = interest
        self.term = term
        self.monthlyPayments = monthlyPayments
        self.monthlyInterestRate = (self.interest / percentConvertor) / monthInYear
    }
    
    func monthlyPayment() -> Double {
        let power = Double(truncating: pow((Decimal)(1 + self.monthlyInterestRate), self.term) as NSNumber)
        let numerator = self.creditCardBalance * (self.monthlyInterestRate * power)
        let denominator = power - 1

        let roundedMonthly = ((numerator / denominator) * percentConvertor).rounded() / percentConvertor
    
        return roundedMonthly
    }
    
    // Source of Formula
    // https://www.calculatorsoup.com/calculators/financial/loan-repayment-calculator.php
    func howLong() -> Int {
        
        let monthlyNumerator = self.monthlyPayments / self.monthlyInterestRate
        if (monthlyNumerator <= self.creditCardBalance){
            return -1
        }
        let monthlyDenominator = monthlyNumerator - self.creditCardBalance
        
        let numerator = log((monthlyNumerator / monthlyDenominator)) // Could also do isNaN
        let denominator = log((1 + self.monthlyInterestRate))
        
        let numberOfMonths = Int(numerator / denominator)
        
        return numberOfMonths
    }
}
