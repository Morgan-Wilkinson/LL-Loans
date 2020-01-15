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
    
    var body: some View {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        // Calculate Date remainer
        return VStack {
            List {
                Section(header: Text("Introduction").font(.headline)){
                    VStack(alignment: .leading){
                        Text("This loan starting date is \(formatter1.string(from: loanItem.startDate ?? Date())) and the length of this loan is \(loanItem.termMonths ?? 0)!")
                            
                        //Divider()
                        Spacer()
                        Text("The starting principal was $\(loanItem.originalPrincipal ?? 0) and the current amount owed is $\(loanItem.currentPrincipal ?? 0)")
                        Text("The interest rate is \(loanItem.interestRate ?? 0)%.")
                    }
                }
                
                Section(header: Text("Analysis of Loan History").font(.headline)){
                    VStack(alignment: .leading){
                        Text("It has been \(0) months since the terms of this loan began. There is \(100) months remaining for this loan to be payed off.")
                        Text("There is \(formatter1.string(from: loanItem.remainingMonths ?? Date())) months remaining for this loan to be payed off.")
                        Spacer()
                        Spacer()
                        Text("With your regular payments of $\(100) a month, you will actually pay off this loan in \(100) months.")
                    }
                }
            }.navigationBarTitle("\(loanItem.name ?? "")")
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
