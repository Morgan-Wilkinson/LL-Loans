//
//  CreditCardPayoff.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/21/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct CreditCardPayoff: View {
    @State private var formCreditCardBalance = ""
    @State private var formInterestRate = ""
    @State private var formPaymentPerMonth = ""
    @State private var formDesiredMonthPayoff = ""
    
    @State private var  creditCardBalance: Double = 0
    @State private var term: Double = 0
    @State private var total: Double = 0
    @State private var monthlyPayments: Double = 0
    @State private var totalInterest: Double = 0
    @State private var showAnswer: Bool = false
    @State private var showPaymentError: Bool = false
    
    let doubleValueSpec: String = "%.2f"
    let intValueSpec: String = "%.0f"
    let formatter = NumberFormatter()
    
    var disableForm: Bool {
        formCreditCardBalance.isEmpty || formInterestRate.isEmpty ||
            (formPaymentPerMonth.isEmpty && formDesiredMonthPayoff.isEmpty) ||
            // Handles both being filled
            (!formPaymentPerMonth.isEmpty || formDesiredMonthPayoff.isEmpty) &&
            (formPaymentPerMonth.isEmpty || !formDesiredMonthPayoff.isEmpty)
            //
            || formCreditCardBalance == "0" || formInterestRate == "0" || (formPaymentPerMonth == "0" && formDesiredMonthPayoff == "0")
    }
    
    func paymentPerMonthIsFilled(changed: Bool){
        self.formPaymentPerMonth = ""
    }
    
    func desiredMonthIsFilled(changed: Bool){
        self.formDesiredMonthPayoff = ""
    }
    
    var body: some View {
        return List {
            Group{
                Section(header: ExplainationHeader(title: "Credit Card Balance", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                    HStack{
                        Spacer()
                        Image(systemName: "dollarsign.circle")
                        TextField("Credit card's balance?", text: self.$formCreditCardBalance)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                }
                Section(header: ExplainationHeader(title: "Credit Card's Interest Rate", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                    HStack{
                        TextField("Credit card's interest rate?", text: self.$formInterestRate)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                        Image(systemName: "percent")
                        Spacer()
                    }
                }
            }
            Group{
                Section(header: ExplainationHeader(title: "Payment Per Month (PPM)", nameIcon: "dollarsign.circle", moreInfoIcon: "questionmark.circle", explanation: "Enter a value for either PPM or DMP")){
                    HStack{
                        ZStack{
                            HStack{
                                TextField("Payment Per Month", text: self.$formPaymentPerMonth, onEditingChanged: self.desiredMonthIsFilled)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.decimalPad)
                            }
                        }
                    }
                }
                Section(header: ExplainationHeader(title: "Desired Months To Payoff (DMP)", nameIcon: "calendar", moreInfoIcon: "questionmark.circle", explanation: "Enter a value for either PPM or DMP")){
                    HStack{
                        ZStack{
                            HStack{
                                TextField("Desired Months to Payoff", text: self.$formDesiredMonthPayoff, onEditingChanged: self.paymentPerMonthIsFilled)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                }
            }
            
            // Calculate Button
            Button(action: ({
                self.showPaymentError = false
                self.showAnswer = false
                
                self.creditCardBalance = Double(self.formCreditCardBalance) ?? 0
                let interestRate = Double(self.formInterestRate) ?? 0
                
                if !self.formPaymentPerMonth.isEmpty {
                    self.monthlyPayments = Double(self.formPaymentPerMonth) ?? 0
                    let calculator = CreditCardCalculator(creditCardBalance: self.creditCardBalance, interest: interestRate, term: self.term, monthlyPayments: self.monthlyPayments)
                    
                    self.term = calculator.howLong()
                   
                    if self.term <= -1 {
                        self.showPaymentError = true
                    }
                }
                
                else if !self.formDesiredMonthPayoff.isEmpty {
                    self.term = Double(self.formDesiredMonthPayoff) ?? 0
                    let calculator = CreditCardCalculator(creditCardBalance: self.creditCardBalance, interest: interestRate, term: self.term, monthlyPayments: self.monthlyPayments)
                    
                    self.monthlyPayments = calculator.monthlyPayment()
                }
                
                if !self.showPaymentError {
                    self.total = self.monthlyPayments * Double(self.term)
                    self.totalInterest = self.total - self.creditCardBalance
                    self.showAnswer = true
                }
                
            })) {
                HStack{
                    Text("Calculate")
                        .fontWeight(.bold)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                }.foregroundColor(Color.bigButtonText)
                .listRowBackground(Color.bigButton)
            }.disabled(self.disableForm)
            
            // Results
            if self.showAnswer {
                VStack(alignment: .leading) {
                    HStack{
                        Text("Total:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("\(self.total, specifier: self.doubleValueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                    HStack{
                        Text("Principal Paid:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("\(self.creditCardBalance, specifier: self.doubleValueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                    HStack{
                        Text("Interest Paid:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("\(self.totalInterest, specifier: self.doubleValueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                    HStack{
                        Text("Monthly Payment:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("$\(self.monthlyPayments, specifier: self.doubleValueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                    HStack{
                        Text("Months to payoff:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("\(self.term, specifier: self.intValueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                }
                .animation(.linear(duration: 0.3))
                .padding()
            }
            
            if self.showPaymentError {
                VStack(alignment: .leading) {
                    HStack{
                        Text("Your planned payment is too low.")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                    }
                }.padding()
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Credit Card Payoff")
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.blue)
        .onTapGesture {
            self.endEditing(true)
        }
    }
}

struct CreditCardPayoff_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardPayoff()
    }
}
