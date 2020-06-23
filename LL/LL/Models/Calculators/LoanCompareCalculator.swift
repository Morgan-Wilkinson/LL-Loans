//
//  LoanCompareCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/19/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import SwiftUI

class LoanCompareCalculator {
    var principal: Double
    var loans: [LoanItem]
    var loanCompareResults: [LoanCompareResults] = []
    let monthInYear: Double = 12
    let percentConvertor: Double = 100
    
    init (principal: Double, loans: [LoanItem]) {
        self.principal = principal
        self.loans = loans
        
        for loan in self.loans {
            let monthlyIntRate = (loan.interest! / percentConvertor) / monthInYear
            loanCompareResults.append(LoanCompareResults(id: UUID(), name: loan.name, monthlyInterestRate: monthlyIntRate, monthlyPayment: nil, totalInterest: nil, totalPayments: nil))
        }
    }
    
    func monthlyPaymentTPaymentTInterest() -> [LoanCompareResults]  {
        for i in 0..<self.loans.count {
            
            let power = Double(truncating: pow((Decimal)(1 + self.loanCompareResults[i].monthlyInterestRate!), Int(self.loans[i].months!)) as NSNumber)
            let numerator = self.principal * (self.loanCompareResults[i].monthlyInterestRate! * power)
            let denominator = power - 1

            let roundedMonthly = ((numerator / denominator) * percentConvertor).rounded() / percentConvertor
            
            // Monthly Payments
            self.loanCompareResults[i].monthlyPayment = roundedMonthly
            // Total Payments
            self.loanCompareResults[i].totalPayments = self.loanCompareResults[i].monthlyPayment! * Double(self.loans[i].months!)
            // Total Interest
            self.loanCompareResults[i].totalInterest = self.loanCompareResults[i].totalPayments! - self.principal
        }
        
        return self.loanCompareResults
    }
}
