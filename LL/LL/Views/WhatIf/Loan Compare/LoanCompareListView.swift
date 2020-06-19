//
//  LoanCompareListView.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LoanCompareListView: View {
    @State var loans: [LoanItem] = [LoanItem(id: 0, principal: nil, interest: nil, years: nil, months: nil), LoanItem(id: 0, principal: nil, interest: nil, years: nil, months: nil)]
    @State var calculate: Bool = false
    @State var incomplete: Bool = true
    @State private var formPrincipal = ""
    
    var body: some View {
        List() {
            Button(action: {
                self.calculate = true
                
                if !self.incomplete {
                    print("Good")
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
                self.loans.append(LoanItem(id: self.loans.count + 1, principal: nil, interest: nil, years: nil, months: nil))
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
                }
            }
        }.environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Loan Comparison")
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.blue)
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
