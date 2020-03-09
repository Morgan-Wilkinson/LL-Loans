//
//  LoanDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LoanDetail: View {
    var loanItem: Loans
    var myCalendar = Calendar.current
    
    var body: some View {
        let calculator = PaymentsCal(loan: self.loanItem)
        let paymentBreakdown = calculator.mortgageMonthlyPrincipaInterestlBalance()
        let test = Calendar.current.dateComponents([.month, .day], from: loanItem.startDate, to: Date())
        let formatter1 = DateIntervalFormatter()
        formatter1.dateStyle = .short
        formatter1.timeStyle = .none
        
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .short
        
        //loanItem.regularPayments = paymentBreakdown.0
        return VStack {
          VStack{
                Card(subtitle: "West Bank", title: "Loan A", briefSummary: "Next Payment - 24th June, 2020 for $\(paymentBreakdown.0)", description: "Principal: $\(paymentBreakdown.1) \nInterest: $\(paymentBreakdown.2) \nBalance: $\(paymentBreakdown.3)")
               Card(subtitle: "", title: "Loan A", briefSummary: "This is a test Loan", description: "")
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

/*
struct LoanDetail_Previews: PreviewProvider {
    static var previews: some View {
        LoanDetail(loanItem: Loans(context: self.managed))
    }
}


 Loans(remainingMonths: Date(), startDate: Date(), nextDueDate: Date(), prevDueDate: Date(), currentDueDate: Date(), termMonths: 24, interestRate: 0.5, currentPrincipal: 10000, originalPrincipal: 12000, regularPayments: 500, name: "Example Loan", about: "This is an example loan item.", id: UUID())
 */

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
