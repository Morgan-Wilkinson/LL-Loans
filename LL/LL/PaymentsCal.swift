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
    var oriPrincipal: Double
    var curPrincipal: Double
    var months: Int
    var timeTracker: DateComponents
    
    
    init(loan: Loans){
        // Loan Item
        self.loan = loan
        
        // Loan Variables.
        self.interest = Double(truncating: (self.loan.interestRate))
        self.oriPrincipal = Double(truncating: (self.loan.originalPrincipal))
        self.curPrincipal = Double(truncating: (self.loan.originalPrincipal)) /////////////////
        self.months = (Int)(truncating: self.loan.termMonths)
        self.monthlyIntRate = interest/12 // 12 due to 12 months
        timeTracker = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date())
    }
    
    // Mortgage", "Refinance", "Home Equity", "Car | Auto", "Personal", "Business", "Student", "Installment", "Payday", "Debt Consolidation"
    
    // P = L[c(1 + c)n]/[(1 + c)n - 1]
    func mortgageMonthly() -> Double {

        let power = Double(truncating: pow((Decimal)(1 + self.monthlyIntRate), self.months) as NSNumber)
        let numerator = self.oriPrincipal * (self.monthlyIntRate * power)
        let denominator = power - 1

        let roundedMonthly = ((numerator / denominator) * 100).rounded() / 100
    
        return roundedMonthly
    }
    
    // Returns the interest for the based off the curPrinicpal.
    func currentInterest() -> Double{
        let currentInterest = ((self.monthlyIntRate * self.curPrincipal) * 100).rounded() / 100 // Maybe chance oriPrincipal to loan.current balance?
        return currentInterest
    }
    
    func currentPrincipal() -> Double {
        let currentPrincipal = ((self.mortgageMonthly() - self.currentInterest()) * 100).rounded() / 100
        return currentPrincipal
    }
    
    // B = L[(1 + c)n - (1 + c)p]/[(1 + c)n - 1]
    // Calculates the balance after P Months
    func mortgageBalanceAfterPMonths(passedMonths: Int) -> Double {
        // replae self.months with however months are left from the current date
        let powerNMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), self.months) as NSNumber)
        let powerPMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), passedMonths) as NSNumber) // 5 months left
        let numerator2 = self.oriPrincipal * (powerNMonths - powerPMonths)
        let denominator2 = powerNMonths - 1

        let roundedBalance = ((numerator2 / denominator2) * 100).rounded() / 100
        
        return roundedBalance
    }
    
    // Returns the balance for the current month.
    func mortgageBalanceForCurrentDate() -> Double {
        let passedMonths = self.timeTracker.month!
        let remainingMonths = Int(truncating: self.loan.termMonths) - passedMonths
        
        // replae self.months with however months are left from the current date
        let powerNMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), self.months) as NSNumber)
        let powerPMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), remainingMonths) as NSNumber) // 5 months left
        let numerator2 = self.oriPrincipal * (powerNMonths - powerPMonths)
        let denominator2 = powerNMonths - 1

        let roundedBalance = ((numerator2 / denominator2) * 100).rounded() / 100
        
        return roundedBalance
    }
    
    func mortgageMonthlyPrincipaInterestBalance() -> (Double, Double, Double, Double) {
        let monthlyPayment = self.mortgageMonthly()
        let currentInterest = ((self.monthlyIntRate * self.curPrincipal) * 100).rounded() / 100 // Maybe chance oriPrincipal to loan.current balance?
        let currentPrincipal = ((monthlyPayment - currentInterest) * 100).rounded() / 100
        loan.currentPrincipal = NSNumber(value: currentPrincipal)
        let currentBalance = ((Double(truncating: self.loan.currentPrincipal as NSNumber) - mortgageMonthly()) * 100).rounded() / 100
    
        return (monthlyPayment, currentPrincipal, currentInterest, currentBalance)
    }
    
    func arrayBalancePrincipalInterest() -> ([Double], [Double], [Double]) {
        var balanceArray: [Double] = []
        var principalArray: [Double] = []
        var interestArray: [Double] = []
        
        for month in 1...months {
            balanceArray.append(mortgageBalanceAfterPMonths(passedMonths: month))
        }
        return (balanceArray, principalArray, interestArray)
    }
}
