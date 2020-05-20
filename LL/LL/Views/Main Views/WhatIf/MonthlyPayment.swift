//
//  MonthlyPayment.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/17/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct MonthlyPayment: View {
    @State private var formPrincipal = ""
    @State private var formInterestRate = ""
    @State private var formTermYears = ""
    @State private var formTermMonths = ""
    
    @State private var monthlyPayments: Double = 0
    @State private var totalInterest: Double = 0
    @State private var showAnswer: Bool = false
    
    let valueSpec: String = "%.2f"
    let textBoxColor = Color("TextFieldBox")
    let cardColor = Color("Cards")
    let bigButtonText = Color("BigButtonText")
    let bigButtonColor = Color("BigButtonColor")
    let formatter = NumberFormatter()
    
    var disableForm: Bool {
        formPrincipal.isEmpty || formInterestRate.isEmpty || (formTermYears.isEmpty && formTermMonths.isEmpty) || formPrincipal == "0" || formInterestRate == "0" || (formTermYears == "0" && formTermMonths == "0")
    }
    var body: some View {
        return VStack{
            List {
                Group{
                    Section(header: ExplainationHeader(title: "Principal", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                        HStack{
                            Spacer()
                            Image(systemName: "dollarsign.circle")
                            TextField("What's the principal?", text: self.$formPrincipal)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.all)
                                .cornerRadius(5)
                        }
                    }
                    Section(header: ExplainationHeader(title: "Annual Interest Rate (APR)", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                        HStack{
                            TextField("What's the annual interest rate (APR)?", text: self.$formInterestRate)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.all)
                                .cornerRadius(5)
                            Image(systemName: "percent")
                            Spacer()
                        }
                    }
                }
                Group{
                    Section(header: ExplainationHeader(title: "Term", nameIcon: "hourglass.bottomhalf.fill", moreInfoIcon: "questionmark.circle", explanation: "Enter the loan's terms in either years, months or both.")){
                        HStack{
                            ZStack{
                                HStack{
                                    TextField("Years", text: self.$formTermYears)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding([.top, .leading, .bottom])
                                        .cornerRadius(5)
                                    Text("Years")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                            Divider()
                            ZStack{
                                HStack{
                                    TextField("Months", text: self.$formTermMonths)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding([.top, .leading, .bottom])
                                        .cornerRadius(5)
                                    Text("Months")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
                // Calculate Button
                Button(action: ({
                    if self.formTermYears.isEmpty == false {
                        let months = self.formatter.number(from: self.formTermMonths) ?? 0
                        let years = self.formatter.number(from: self.formTermYears) ?? 0
                        
                        self.formTermMonths = "\((Int(truncating: years) * 12) + Int(truncating: months))"
                        self.formTermYears = ""
                    }
                    let principal = Double(self.formPrincipal) ?? 0
                    let interestRate = Double(self.formInterestRate) ?? 0
                    let termMonths = Int(self.formTermMonths) ?? 0
                    
                    let calculator = MonthlyPaymentWhatIf(principal: principal, interestRate: interestRate, months: termMonths)
                    self.monthlyPayments = calculator.mortgageMonthly()
                    self.totalInterest = calculator.totalInterest()
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
                        Text("Your monthly payment would be $\(self.monthlyPayments, specifier: self.valueSpec).")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Text("Your total interest would be $\(self.totalInterest, specifier: self.valueSpec).")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
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

struct MonthlyPayment_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPayment()
    }
}
