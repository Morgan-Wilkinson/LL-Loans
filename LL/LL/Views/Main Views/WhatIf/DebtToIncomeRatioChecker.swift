//
//  RefinanceChecker.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/17/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct DebtToIncomeRatioChecker: View {
    @State private var formIncome = ""
    @State private var formDebt = ""
    
    @State private var ratio: Int = 0
    @State private var showAnswer: Bool = false
    
    let valueSpec: String = "%.2f"
    let textBoxColor = Color("TextFieldBox")
    let cardColor = Color("Cards")
    let bigButtonText = Color("BigButtonText")
    let bigButtonColor = Color("BigButtonColor")
    let formatter = NumberFormatter()
    
    var disableForm: Bool {
        formIncome.isEmpty || formDebt.isEmpty || formIncome == "0" || formDebt == "0"
    }
    var body: some View {
        return VStack{
            List {
                Group{
                    Section(header: ExplainationHeader(title: "Gross Income", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Gross income is the sum of all wages and profits")){
                        HStack{
                            Spacer()
                            Image(systemName: "dollarsign.circle")
                            TextField("What's your gross income?", text: self.$formIncome)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.all)
                                .cornerRadius(5)
                        }
                    }
                    Section(header: ExplainationHeader(title: "Gross Debt", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Gross debt is the sum of all expenses")){
                        HStack{
                            Spacer()
                            Image(systemName: "dollarsign.circle")
                            TextField("What's your gross debt?", text: self.$formDebt)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.all)
                                .cornerRadius(5)
                        }
                    }
                }
                
                // Calculate Button
                Button(action: ({
                    let grossIncome = Double(self.formIncome) ?? 0
                    let grossDebt = Double(self.formDebt) ?? 0
    
                    let calculator = DebtToIncomeCalculator(income: grossIncome, debt: grossDebt)
                    self.ratio = calculator.Ratio()
                    self.showAnswer = true
                })) {
                    HStack{
                        Text("Calculate")
                            .fontWeight(.bold)
                            .font(.title)
                            .multilineTextAlignment(.leading)
                    }.foregroundColor(self.bigButtonText)
                    .listRowBackground(bigButtonColor)
                }.disabled(self.disableForm)
                
                // Results 
                if self.showAnswer {
                    VStack(alignment: .leading) {
                        if self.ratio <= 36 {
                            Text("Your Debt to Income Ratio is \(self.ratio)%. This is considered ideal as it is under 36%")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                
                        }
                        else if ((self.ratio > 36) && (self.ratio <= 50)) {
                            Text("Your Debt to Income Ratio is \(self.ratio)%. This is considered ok as it is still under 50%. Having a DTI ratio of 36% or less is considered ideal. Paying down debt or increasing your income can help improve your DTI ratio.")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                
                        }
                        else {
                            Text("Your Debt to Income Ratio is \(self.ratio)%. You're Debt to Income Ratio has exceeded the limit. 50% is usually the highest Debt to Income Ratio that lenders will allow. Paying down debt or increasing your income can improve your DTI ratio.")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                
                        }
                    }.padding()
                }
            }.environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Monthly Payment")
            .buttonStyle(PlainButtonStyle())
            .listStyle(GroupedListStyle())
            .foregroundColor(Color.blue)
                
            
        }
    }
}

struct DebtToIncomeRatioChecker_Previews: PreviewProvider {
    static var previews: some View {
        DebtToIncomeRatioChecker()
    }
}
