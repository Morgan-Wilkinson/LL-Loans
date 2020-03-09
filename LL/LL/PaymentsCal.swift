//
//  PaymentsCal.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/20/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

class PaymentsCal {
    var loan: Loans
    var interest: Double
    var monthlyIntRate: Double
    var principal: Double
    var months: Int
    
    
    init(loan: Loans){
        // Loan Item
        self.loan = loan
        
        // Loan Variables.
        self.interest = Double(truncating: (self.loan.interestRate))
        self.principal = Double(truncating: (self.loan.originalPrincipal))
        self.months = (Int)(truncating: self.loan.termMonths)
        self.monthlyIntRate = interest/12 // 12 due to 12 months
    }
    
    // Mortgage", "Refinance", "Home Equity", "Car | Auto", "Personal", "Business", "Student", "Installment", "Payday", "Debt Consolidation"
    
    // P = L[c(1 + c)n]/[(1 + c)n - 1]
    func mortgageMonthly() -> Double {

        let power = Double(truncating: pow((Decimal)(1 + self.monthlyIntRate), self.months) as NSNumber)
        let numerator = self.principal * (self.monthlyIntRate * power)
        let denominator = power - 1

        let roundedMonthly = ((numerator / denominator) * 100).rounded() / 100
    
        return roundedMonthly
    }
    
    // B = L[(1 + c)n - (1 + c)p]/[(1 + c)n - 1]
    func mortgageBalanceAfterPMonths() -> Double {
        // replae self.months with however months are left from the current date
        let powerNMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), self.months) as NSNumber)
        let powerPMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), 5) as NSNumber) // 5 months left
        let numerator2 = self.principal * (powerNMonths - powerPMonths)
        let denominator2 = powerNMonths - 1

        let roundedBalance = ((numerator2 / denominator2) * 100).rounded() / 100
        
        return roundedBalance
    }
    
    func mortgageMonthlyPrincipaInterestlBalance() -> (Double, Double, Double, Double) {
        let monthlyPayment = self.mortgageMonthly()
        let currentInterest = ((self.monthlyIntRate * self.principal) * 100).rounded() / 100 // Maybe chance principal to loan.current balance?
        let currentPrincipal = ((monthlyPayment - currentInterest) * 100).rounded() / 100
        let currentBalance = ((Double(truncating: self.loan.currentPrincipal as NSNumber) - mortgageMonthly()) * 100).rounded() / 100
    
        return (monthlyPayment, currentPrincipal, currentInterest, currentBalance)
    }
    
   
}

/*
 @NSManaged public var remainingMonths: Date
 @NSManaged public var startDate: Date
 @NSManaged public var nextDueDate: Date
 @NSManaged public var prevDueDate: Date
 @NSManaged public var currentDueDate: Date
 @NSManaged public var termMonths: NSNumber
 @NSManaged public var interestRate: NSNumber
 @NSManaged public var currentPrincipal: NSNumber
 @NSManaged public var originalPrincipal: NSNumber
 @NSManaged public var regularPayments: NSNumber
 @NSManaged public var name: String
 @NSManaged public var about: String
 @NSManaged public var id: UUID
 
 */
