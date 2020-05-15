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
        let paymentsCalculator = PaymentsCal(loan: self.loanItem)
        let monthlyPayment = paymentsCalculator.mortgageMonthly()
        let balanceArray = paymentsCalculator.arrayBalanceInterestPrincipal()
        
        // Months formator
        let allMonthSeries = paymentsCalculator.allMonthsSeries()
        var smallMonths: [[Double]] = []
        for array in balanceArray {
            smallMonths.append(paymentsCalculator.smallMonthsValues(array: array))
            //print("")
        }
        // Months arrays
        let smallMonthSeries = paymentsCalculator.smallMonthSeries(length: smallMonths[0].count)
        
        // The array is set to have index four be the current Month or any month less than 4.
        let threeMonthBuffer = 3
        let leeway  = Calendar.current.dateComponents([.month, .day], from: loanItem.startDate, to: Date()).month!
        let currentMonth = leeway > threeMonthBuffer ? 3 : leeway
        
        // Formatters for Date style
        let formatter1 = DateIntervalFormatter()
        let formatter2 = DateFormatter()
        
        formatter1.dateStyle = .short
        formatter1.timeStyle = .none
        formatter2.dateStyle = .short
        formatter2.dateFormat = "d MMM y"
        
        return GeometryReader { geometry in
            ScrollView {
                VStack{
                    // Loan Payment at a glance.
                    Card(subtitle: "\(self.loanItem.origin)", title: "\(self.loanItem.name) - \(self.loanItem.typeOfLoan) Loan", overview: "Next Payment - \(formatter2.string(from: self.loanItem.nextDueDate)) for $\(monthlyPayment)",
                        briefSummary: "Principal: $\(smallMonths[2][currentMonth]) \nInterest: $\(smallMonths[1][currentMonth]) \nBalance: $\(smallMonths[0][currentMonth])", description: "\(self.loanItem.about)", month: "\(formatter2.string(from:self.loanItem.nextDueDate - 2628000))")
                    
                    // Amortization Schedule
                    BarView(title: "History & Projections", currentMonthIndex: currentMonth, monthsSeries: smallMonthSeries, barValues: smallMonths)
                    
                
                    NavigationLink(destination: PaymentBreakdownDetail(title: "Amortization Schedule", monthsSeries: allMonthSeries, barValues: balanceArray)) {
                        Text("Amortization Schedule")
                            .fontWeight(.bold)
                            .font(.headline)
                            .padding(.horizontal, 50.0)
                            .padding(.vertical, 12.0)
                            .background(Color.green)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                    }
                }.frame(height: geometry.size.height)
            }
            .navigationBarTitle("\(self.loanItem.name.capitalizingFirstLetter())")
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
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
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
