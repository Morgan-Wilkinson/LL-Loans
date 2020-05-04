//
//  LoanDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Combine
import SwiftUI

struct LoanDetail: View{
    var loanItem: Loans
    @State private var showModal = false
    
    var body: some View {
        // Data calculators
        let calculator = PaymentsCal(loan: self.loanItem)
        let monthlyPayment = calculator.mortgageMonthly()
        let balanceArray = calculator.arrayBalanceMonInterestMonPrincipal()
        
        var smallMonths: [[Double]] = []
        for array in balanceArray {
            smallMonths.append(calculator.smallMonthsValues(array: array))
            //print("")
        }
        
        // Months arrays
        let smallMonthSeries = calculator.smallMonthSeries(length: smallMonths[0].count)
        
        // Time from start to now
        let timeTracker = Calendar.current.dateComponents([.month, .day], from: loanItem.startDate, to: Date())
        
        // Formatters for Date style
        let formatter1 = DateIntervalFormatter()
        let formatter2 = DateFormatter()
        
        formatter1.dateStyle = .short
        formatter1.timeStyle = .none
        
        formatter2.dateStyle = .short
        formatter2.dateFormat = "d MMM y"
        
        return VStack {
            VStack{
                // Loan Payment at a glance.
                Card(subtitle: "\(loanItem.origin)", title: "\(loanItem.name) - \(loanItem.typeOfLoan) Loan", overview: "Next Payment - \(formatter2.string(from: loanItem.nextDueDate)) for $\(monthlyPayment)",
                    briefSummary: "Principal: $\(smallMonths[2][timeTracker.month!]) \nInterest: $\(smallMonths[1][timeTracker.month!]) \nBalance: $\(smallMonths[0][timeTracker.month!])", description: "\(loanItem.about)", month: "\(formatter2.string(from:loanItem.nextDueDate - 2628000))")
                // Amortization Schedule
                BarView(title: "History & Projections", monthsSeries: smallMonthSeries, barValues: smallMonths)
                //AdjustPayment()
               
           }
            /*
            List {
                Section(header: Text("Analysis of Loan History").font(.headline), footer: Text("Here you can find information about your payments and the remaining time for your loan.")){
                    VStack(alignment: .leading){
                        Text("Time passed: \(test.month!) months and \(test.day!) days.")
                        Text("Time remaining: \(Int(truncating: loanItem.termMonths) - test.month!) months.")
                    
                        Spacer()
                        Spacer()
                        Text("With your regular payments of $\(loanItem.regularPayments) a month, you will actually pay off this loan in \(cal.finishPayment()) months.")
                    }
                }
            }.navigationBarTitle("\(loanItem.name)")
 */
        }
        .navigationBarTitle("\(loanItem.name.capitalizingFirstLetter()) Data")
        .navigationBarItems(trailing: NavigationLink(destination: LoanEditor(loan: self.loanItem)){
            HStack{
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.medium)
                    Text("Edit")
            }
        })
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
