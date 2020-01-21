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
    
    // var dateItems = Calendar.current.dat
    var body: some View {
        let cal = PaymentsCal(loan: loanItem)
        let test = Calendar.current.dateComponents([.month, .day], from: loanItem.startDate, to: Date())
        let formatter1 = DateIntervalFormatter()
        formatter1.dateStyle = .short
        formatter1.timeStyle = .none
        
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .short

        return VStack {
            // start - current date
            
            List {
                Section(header: Text("Introduction").font(.headline), footer: Text("You can find an overview of your loan and the terms here.")){
                    VStack(alignment: .leading){
                        Text("This starting date of \(loanItem.name) was \(formatter2.string(from: loanItem.startDate)) and the term of this loan is \(loanItem.termMonths) months.")
                            
                        Spacer()
                        Spacer()
                        Text("Starting Principal: $\(loanItem.originalPrincipal)")
                        Text("Current Owed Amount: $\(loanItem.currentPrincipal)")
                        Text("Interest Rate: \(loanItem.interestRate)%.")
                    }
                }
                
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
        }
    }
}

/*
struct LoanDetail_Previews: PreviewProvider {
    static var previews: some View {
        LoanDetail()
    }
}
*/
