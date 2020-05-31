//
//  PaymentsCal.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/20/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import SwiftUI

class PaymentsCal {
    @Environment(\.managedObjectContext) var managedObjectContext
    var loan: Loans
    var interest: Double
    var monthlyIntRate: Double
    var oriPrincipal: Double
    var months: Int
    var timeTracker: DateComponents
    
    let format = DateFormatter()

    init(loan: Loans){
        // Date Format
        format.dateFormat = "MMM yy"
        // Loan Item
        self.loan = loan
        
        // Loan Variables.
        self.interest = Double(truncating: (self.loan.interestRate))
        self.oriPrincipal = Double(truncating: (self.loan.originalPrincipal))
        self.months = (Int)(truncating: self.loan.termMonths)
        self.monthlyIntRate = (interest / 100) / 12 // 12 due to 12 months
        self.timeTracker = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date())
    }
    
    func runner() {
        loan.regularPayments = monthlyPayment()
        
        // Assigns the arrays to temp holders
        var allbalanceArray: [Double] = self.allBalances()
        var allInterestArray: [Double] = self.allInterest(allBalances: allbalanceArray)
        var allPrincipalArray: [Double] = self.allPrincipal(allInterest: allInterestArray)
        var interestTotals: [Double] = self.totalInterestSoFar(interestArray: allInterestArray)
        
        // Removes the parts of the calulation that are of no use to the user.
        allbalanceArray.removeFirst()
        allInterestArray.removeLast()
        allPrincipalArray.removeLast()
        interestTotals.removeLast()
        
        // Assign and save the months values
        loan.balanceArray = allbalanceArray
        loan.interestArray = allInterestArray
        loan.principalArray = allPrincipalArray
        loan.interestTotalsArray = interestTotals
        
        // Assign and save the months strings
        loan.monthsSeries = allMonthsSeries()
    }
    
    func totalInterestSoFar(interestArray: [Double]) -> [Double]{
        var totalInterestSoFar: [Double] = []
        
        totalInterestSoFar.append(interestArray[0])
        for i in 1..<interestArray.count{
            totalInterestSoFar.append(totalInterestSoFar[i - 1] + interestArray[i])
        }
        
        return totalInterestSoFar
    }
    
    func allMonthsSeries() -> [String]{
        let startDate = self.loan.startDate
        var monthsArray: [String] = []
        for index in 1...self.months {
            let next = Calendar.current.date(byAdding: .month, value: index, to: startDate)
            monthsArray.append(format.string(from: next!))
        }
        
       return monthsArray
    }
    
    // B = L[(1 + c)n - (1 + c)p]/[(1 + c)n - 1]
    // Returns an array of the balances after each month starting from the loan start date until the end of the terms.
    func allBalances() -> [Double] {
        var balanceArray: [Double] = []
        let powerNMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), self.months) as NSNumber)
        
        for index in 0...(self.months) {
            let powerPMonths = Double(truncating: pow((Decimal)(1 + monthlyIntRate), index) as NSNumber)
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
        let monthlyPayment = self.monthlyPayment()
        
        for interest in allInterest {
            allPrincipal.append(((monthlyPayment - interest) * 100).rounded() / 100)
        }
        
        return allPrincipal
    }
    
    // P = L[c(1 + c)n]/[(1 + c)n - 1]
    // Returns the monthly payments for this loan based off of the original ammount
    func monthlyPayment() -> Double{

        let power = Double(truncating: pow((Decimal)(1 + self.monthlyIntRate), self.months) as NSNumber)
        let numerator = self.oriPrincipal * (self.monthlyIntRate * power)
        let denominator = power - 1

        let roundedMonthly = ((numerator / denominator) * 100).rounded() / 100
        
        return roundedMonthly
    }

    // Returns the balance for the current month.
    func monthlyBalanceForCurrentDate() -> Double {
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
