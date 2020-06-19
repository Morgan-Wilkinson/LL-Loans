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
    @State var loans: [LoanItem] = [LoanItem(id: 1, interest: nil, years: nil, months: nil), LoanItem(id: 2, interest: nil, years: nil, months: nil)]
    @State var loanResults: [LoanCompareResults] = []
    
    @State var calculate: Bool = false
    @State var incomplete: Bool = false
    @State var showResults: Bool = false
    
    @State private var formPrincipal = ""
    @State var principal: Double = 0
    
    var body: some View {
        List() {
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
            Button(action: {
                self.numberOfLoan += 1
                self.loans.append(LoanItem(id: self.numberOfLoan, interest: nil, years: nil, months: nil))
            }) {
                HStack{
                    Text("Add")
                        .fontWeight(.bold)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                }.foregroundColor(Color.bigButtonText)
                .listRowBackground(Color.bigButton)
                
            }
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
            ForEach(self.loans, id: \.self) { loan in
                Section(header: Text("Loan \(loan.id)")) {
                    LoanCompare(loan: loan, setToCalculate: self.$calculate, incomplete: self.$incomplete)
                    Button(action: {
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
            
            if showResults {
                LoanCompareResultsView(principal: self.principal, loans: self.loans, loanResults: self.loanResults)
            }
        }.environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Loan Comparison")
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.blue)
            .navigationBarItems(trailing: Button(action: {
                self.calculate = false
                self.loans.removeAll()
                self.loans.append(LoanItem(id: 1, interest: nil, years: nil, months: nil))
                self.loans.append(LoanItem(id: 2, interest: nil, years: nil, months: nil))
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
