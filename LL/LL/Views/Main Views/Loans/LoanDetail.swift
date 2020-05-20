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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    var loanItem: Loans
    let bigButtonText = Color("BigButtonText")
    let bigButtonColor = Color("BigButtonColor")
    @State private var showModal = false
    
    var body: some View {
        // The array is set to have index four be the current Month or any month less than 4.
        let threeMonthBuffer = 3
        let leeway  = Calendar.current.dateComponents([.month, .day], from: loanItem.startDate, to: Date()).month!
        let currentMonth = leeway > threeMonthBuffer ? threeMonthBuffer : leeway
        
        // Formatters for Date style
        let formatter1 = DateIntervalFormatter()
        let formatter2 = DateFormatter()
        
        formatter1.dateStyle = .short
        formatter1.timeStyle = .none
        formatter2.dateStyle = .short
        formatter2.dateFormat = "d MMM y"
        
        return GeometryReader { geometry in
            List {
               
                // Loan Payment at a glance.
                Section(header: SectionHeaderView(text: "Loan Summary", icon: "doc.text")) {
                    Card(subtitle: "\(self.loanItem.origin)", title: "\(self.loanItem.name) - \(self.loanItem.typeOfLoan) Loan", overview: "Next Payment - \(formatter2.string(from: self.loanItem.currentDueDate)) for $\(self.loanItem.regularPayments)",
                        briefSummary: "Principal: $\(self.loanItem.smallPrincipalArray[currentMonth]) \nInterest: $\(self.loanItem.smallInterestArray[currentMonth]) \nBalance: $\(self.loanItem.smallBalanceArray[currentMonth])", description: "\(self.loanItem.about)", month: "\(formatter2.string(from:self.loanItem.currentDueDate - 2628000))")
                }
                Section(header: SectionHeaderView(text: "Loan History & Projections", icon: "chart.bar.fill")) {
                    // Current 12 month preview
                    BarView(title: "History & Projections", currentMonthIndex: currentMonth, monthsSeries: self.loanItem.smallMonthsSeries, barValues: [self.loanItem.smallBalanceArray, self.loanItem.smallInterestArray, self.loanItem.smallPrincipalArray])
                    
                }
                // Amortization Schedule
                Section(header: SectionHeaderView(text: "Amortization Schedule")) {
                    NavigationLink(destination: PaymentBreakdownDetail(title: "Amortization Schedule", monthlyPayment: self.loanItem.regularPayments, monthsSeries: self.loanItem.monthsSeries, barValues: [self.loanItem.balanceArray, self.loanItem.interestArray, self.loanItem.principalArray])) {
                        Text("Amortization Schedule")
                            .fontWeight(.bold)
                            .font(.headline)
                            .cornerRadius(5)
                            .foregroundColor(self.bigButtonText)
                    }.listRowBackground(self.bigButtonColor)
                    .buttonStyle(PlainButtonStyle())
                }
               // }.frame(height: geometry.size.height)
            }
            //.listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
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
