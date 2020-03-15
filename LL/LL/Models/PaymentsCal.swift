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
    let Months = ["January","Febrary","March","April","May","June","July","August","September","October","November","December"]
    
    let format = DateFormatter()

    init(loan: Loans){
        // Date Format
        format.dateFormat = "MMM yy"
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
    func monthSeries() -> [String] {
        let startDate = self.loan.startDate
        var months: [String] = []
        
        for index in 0...self.months - 1 {
            var next = Calendar.current.date(byAdding: .month, value: index, to: startDate)
            months.append(format.string(from: next!))
        }
        return months
    }
    
    func arrayBalanceMonInterestMonPrincipal() -> [[Double]] {
        let allbalanceArray: [Double] = self.allBalances()
        let monInterestArray: [Double] = self.allInterest(allBalances: allbalanceArray)
        let monPrincipalArray: [Double] = self.allPrincipal(allInterest: monInterestArray)


        return [allbalanceArray, monInterestArray, monPrincipalArray]
    }
    
    // B = L[(1 + c)n - (1 + c)p]/[(1 + c)n - 1]
    // Returns an array of the balances after each month starting from the loan start date until the end of the terms.
    func allBalances() -> [Double] {
        var balanceArray: [Double] = []
        let powerNMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), self.months) as NSNumber)
        
        for index in 0...(self.months - 1) {
            let powerPMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), index) as NSNumber) // 5 months left
            let numerator2 = self.oriPrincipal * (powerNMonths - powerPMonths)
            let denominator2 = powerNMonths - 1

            balanceArray.append(((numerator2 / denominator2) * 100).rounded() / 100)
        }
        return balanceArray
    }
    
    func normalizedValues(array: [Double]) -> [Double] {
        let max: Double = array.max() ?? 0
        var normalized: [Double] = []
        
        for element in array {
            normalized.append(element / max)
        }
        
        return normalized
    }
    
    // Returns an array of all the interest amounts based off of the array of balanaces
    func allInterest(allBalances: [Double]) -> [Double] {
        var allInterest: [Double] = []

        for balance in allBalances{
            allInterest.append(((self.monthlyIntRate * balance) * 100).rounded() / 100)
        }
        return allInterest
    }
    
    // Returns an array of all the principal amounts based off of the array of interest
    func allPrincipal(allInterest: [Double]) -> [Double] {
        var allPrincipal: [Double] = []
        let monthlyPayment = self.mortgageMonthly()

        for interest in allInterest {
            allPrincipal.append(((monthlyPayment - interest) * 100).rounded() / 100)
        }
        return allPrincipal
    }
    
    // P = L[c(1 + c)n]/[(1 + c)n - 1]
    // Returns the monthly payments for this loan based off of the original ammount
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
}
