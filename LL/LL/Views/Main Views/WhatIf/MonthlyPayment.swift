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
    let formatter = NumberFormatter()
    
    var disableForm: Bool {
        formPrincipal.isEmpty || formInterestRate.isEmpty || (formTermYears.isEmpty && formTermMonths.isEmpty)
    }
    var body: some View {
        return VStack{
            List {
                Group{
                    Section(header: HeaderRowColor(title: "Principal", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(textBoxColor)
                            HStack{
                                Spacer()
                                Image(systemName: "dollarsign.circle")
                                TextField("What's the principal?", text: self.$formPrincipal)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .padding(.all)
                                    .background(textBoxColor)
                                    .cornerRadius(5)
                                    //.padding(.bottom, 20.0)
                            }
                        }
                    }
                    Section(header: HeaderRowColor(title: "Annual Interest Rate (APR)", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(textBoxColor)
                            HStack{
                                TextField("What's the annual interest rate (APR)?", text: self.$formInterestRate)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .padding(.all)
                                    .cornerRadius(5)
                                    //.padding(.bottom, 20.0)
                                Image(systemName: "percent")
                                Spacer()
                            }
                        }
                    }
                }
                Group{
                    Section(header: HeaderRowColor(title: "Term", nameIcon: "hourglass.bottomhalf.fill", moreInfoIcon: "questionmark.circle", explanation: "Enter the loan's terms in either years, months or both!")){
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(textBoxColor)
                                HStack{
                                    TextField("Years", text: self.$formTermYears)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .padding([.top, .leading, .bottom])
                                        .background(textBoxColor)
                                        .cornerRadius(5)
                                        //.padding(.bottom, 20.0)
                                    Text("Years")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                            Divider()
                                
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(textBoxColor)
                                HStack{
                                    TextField("Months", text: self.$formTermMonths)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .padding(.all)
                                        .background(textBoxColor)
                                        .cornerRadius(5)
                                        //.padding(.bottom, 20.0)
                                    Text("Months")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
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
                    
                    let calculator = WhatIfCalculator(principal: principal, interestRate: interestRate, months: termMonths)
                    self.monthlyPayments = calculator.mortgageMonthly()
                    self.totalInterest = calculator.totalInterest()
                    self.showAnswer = true
                })) {
                    HStack{
                        Image(systemName: "plus.slash.minus")
                            .imageScale(.large)
                        Text("Calculate")
                            .fontWeight(.bold)
                            .font(.title)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                    }.foregroundColor(Color("SimpleRow"))
                    .listRowBackground(Color.blue)
                }.disabled(self.disableForm)
                
            }
            .navigationBarTitle("New Loan")
            .buttonStyle(PlainButtonStyle())
            .listStyle(PlainListStyle())
            .listSeparatorStyle(style: .none)
            .foregroundColor(Color.blue)
                
            if self.showAnswer {
                VStack{
                    ZStack{
                        Rectangle()
                            .fill(Color("SimpleRow"))
                            .frame(height: 100)
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
                    }.padding()
                    .shadow(radius: 5)
                }
            }
        }
    }
}

struct MonthlyPayment_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPayment()
    }
}
