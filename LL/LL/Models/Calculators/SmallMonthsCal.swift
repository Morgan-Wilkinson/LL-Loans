//
//  SmallMonthsCal.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/19/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import SwiftUI

class SmallMonthsCal {
    @Environment(\.managedObjectContext) var managedObjectContext
    var loan: Loans
    var months: Int
    let format = DateFormatter()
    
    init(loan: Loans){
        // Date Format
        format.dateFormat = "MMM yy"
        
        // Loan Item
        self.loan = loan
        self.months = (Int)(truncating: self.loan.termMonths)
    }
    
    func runner() {
        // Small Loans Values
        loan.smallBalanceArray = smallMonthsValues(array: loan.balanceArray)
        loan.smallInterestArray = smallMonthsValues(array: loan.interestArray)
        loan.smallPrincipalArray = smallMonthsValues(array: loan.principalArray)
        
        // Small Months Series
        loan.smallMonthsSeries = smallMonthSeries(length: loan.smallPrincipalArray.count)
    }
    
    // Returns an array of the small months values
    func smallMonthsValues(array: [Double]) -> [Double] {
        let fourMonthBuffer = 4
        let leeway  = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date()).month!
        var smallMonths: [Double] = []
        var timeLeft: Int

        // Returns how much months have passed since the start of the loan to the current Date
        let timeBuffer = leeway > fourMonthBuffer ? (leeway - fourMonthBuffer) : 0
        // Returns how much months are left
        let totalMonthsLeft = self.months - leeway
        
        // Decides on how far to go with the array
        if (totalMonthsLeft > 12){
            if((totalMonthsLeft - 1) >= (timeBuffer + 12)){
                timeLeft = timeBuffer + 12
            }
            else{
                timeLeft = totalMonthsLeft - 1 - timeBuffer
            }
        }
        else{
            timeLeft = self.months - 1
        }
        // Add mounts based on the range of time we are in the present.
        for i in timeBuffer...timeLeft{
            smallMonths.append(array[i])
        }
        return smallMonths
    }
    
    // Returns an array of strings of the small months.
    func smallMonthSeries(length: Int) -> [String] {
        var months: [String] = []
        let oneMonth = 2628000
        let threeMonthBuffer = 3
        let checkTimeBuffer = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date()).month!
        // Decides on where to start the array
        let timeBuff = checkTimeBuffer <= threeMonthBuffer ? Date() - TimeInterval((oneMonth * (checkTimeBuffer - 1))) : Date() - TimeInterval(oneMonth * threeMonthBuffer)
        
        for index in 0...length - 1 {
            let next = Calendar.current.date(byAdding: .month, value: index, to: timeBuff)
            months.append(format.string(from: next!))
        }
        
        
        return months
    }
}
