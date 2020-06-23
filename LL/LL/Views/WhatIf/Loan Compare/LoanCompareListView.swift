//
//  LoanCompareListView.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LoanCompareListView: View {
    @State var numberOfLoan = 2
    @State var loans: [LoanItem] = [LoanItem(id: UUID(), name: 1, interest: nil, years: nil, months: nil), LoanItem(id: UUID(), name: 2, interest: nil, years: nil, months: nil)]
    @State var loanResults: [LoanCompareResults] = []
    
    @State var calculate: Bool = false
    @State var incomplete: Bool = false
    @State var showResults: Bool = false
    
    @State private var formPrincipal = ""
    @State var principal: Double = 0
    
    // Fix Incomplete 
    var body: some View {
        List() {
            // Calculate
            Button(action: {
                self.calculate = true
                
                if !self.incomplete {
                    self.principal = Double(self.formPrincipal) ?? 0
                    let calculator = LoanCompareCalculator(principal: self.principal, loans: self.loans)
                    self.loanResults = calculator.monthlyPaymentTPaymentTInterest()
                    self.showResults = true
                }
            }) {
                HStack{
                    Text("Calculate")
                        .fontWeight(.bold)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                }.foregroundColor(Color.bigButtonText)
                .listRowBackground(Color.bigButton)
            }
            // Add loan
            Button(action: {
                self.numberOfLoan += 1
                self.loans.append(LoanItem(id: UUID(), name: self.numberOfLoan, interest: nil, years: nil, months: nil))
            }) {
                HStack{
                    Text("Add")
                        .fontWeight(.bold)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                }.foregroundColor(Color.bigButtonText)
                .listRowBackground(Color.bigButton)
            }
            
            // Principal
            Group {
                Section(header: ExplainationHeader(title: "Principal", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                    HStack{
                        Spacer()
                        Image(systemName: "dollarsign.circle")
                        TextField("What's the principal?", text: self.$formPrincipal)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            // Loan Entries
            ForEach(self.loans) { loan in
                Section(header: Text("Loan \(loan.name)")) {
                    LoanCompare(loan: loan, setToCalculate: self.$calculate, incomplete: self.$incomplete)
                    Button(action: {
                        self.showResults = false
                        self.loans.removeAll(where: {$0 == loan})
                    }){
                        HStack{
                            Image(systemName: "trash")
                                .foregroundColor(.blue)
                                .imageScale(.medium)
                            Text("Delete")
                        }
                    }
                }
            }
            
            // Loan Results
            if showResults {
                LoanCompareResultsView(principal: self.$principal, loanResults: self.loanResults)
            }
             
        }.environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Loan Comparison")
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.blue)
        .navigationBarItems(trailing: Button(action: {
            self.showResults = false
            self.calculate = false
            self.formPrincipal = ""
            self.principal = 0
            self.loans.removeAll()
            self.loans.append(LoanItem(id: UUID(), name: 1, interest: nil, years: nil, months: nil))
            self.loans.append(LoanItem(id: UUID(), name: 2, interest: nil, years: nil, months: nil))
            self.numberOfLoan = 2
        }){
            HStack{
                Image(systemName: "trash")
                    .foregroundColor(.blue)
                    .imageScale(.medium)
                Text("Reset All")
            }
        })
        .onTapGesture {
            self.endEditing(true)
        }
    }
}

struct LoanCompareListView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCompareListView()
    }
}
