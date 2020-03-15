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
    var myCalendar = Calendar.current
    @State private var showModal = false
    
    var body: some View {
        let calculator = PaymentsCal(loan: self.loanItem)
        //let paymentBreakdown = calculator.mortgageMonthlyPrincipaInterestBalance()
        //let remainingBalance = calculator.mortgageBalanceForCurrentDate()
        let monthlyPayment = calculator.mortgageMonthly()
        let balanceArray = calculator.arrayBalanceMonInterestMonPrincipal()
        var normalizedArray: [[CGFloat]] = []
        for array in balanceArray {
            normalizedArray.append(calculator.normalizedValues(array: array))
        }
        
        let timeTracker = Calendar.current.dateComponents([.month, .day], from: loanItem.startDate, to: Date())
        let formatter1 = DateIntervalFormatter()
        let formatter2 = DateFormatter()
        
        formatter1.dateStyle = .short
        formatter1.timeStyle = .none
        
        formatter2.dateStyle = .short
        formatter2.dateFormat = "d MMM y"
        
        return VStack {
            VStack{
                // Loan Payment at a glance.
                Card(subtitle: "Payment's At A Glance", title: "\(loanItem.origin) - \(loanItem.typeOfLoan) Loan", briefSummary: "Next Payment - \(formatter2.string(from: loanItem.nextDueDate)) for $\(monthlyPayment)", description: "Principal: $\(balanceArray[2][timeTracker.month!]) \nInterest: $\(balanceArray[1][timeTracker.month!]) \nBalance: $\(balanceArray[0][timeTracker.month!])")
                // Amortization Schedule
                //Card(subtitle: "Amortization Schedule", title: "", briefSummary: "", description: "\(remainingBalance)")
                //BarChartView(chartData: balanceArray, normalizedChartData: normalizedArray,data: ChartData(points: balanceArray[2]), title: "Title", legend: "Legendary", form: ChartForm.large)
                
               // BarRow(barValues: normalizedArray)
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
