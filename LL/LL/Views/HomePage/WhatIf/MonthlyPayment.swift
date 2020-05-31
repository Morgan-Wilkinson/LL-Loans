//
//  MonthlyPayment.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/17/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct MonthlyPayment: View {
    @State private var formPrincipal = ""
    @State private var formInterestRate = ""
    @State private var formTermYears = ""
    @State private var formTermMonths = ""
    
    @State private var monthlyPayments: Double = 0
    @State private var totalInterest: Double = 0
    @State private var termMonths: Int = 0
    @State private var showAnswer: Bool = false
    
    // Ads
    @State var interstitial: GADInterstitial!
    let adID: String = "ca-app-pub-3940256099942544/4411468910"
    
    let valueSpec: String = "%.2f"
    let formatter = NumberFormatter()
    
    var disableForm: Bool {
        formPrincipal.isEmpty || formInterestRate.isEmpty || (formTermYears.isEmpty && formTermMonths.isEmpty) || formPrincipal == "0" || formInterestRate == "0" || (formTermYears == "0" && formTermMonths == "0")
    }
    var body: some View {
        return List {
            Group{
                Section(header: ExplainationHeader(title: "Principal", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                    HStack{
                        Spacer()
                        Image(systemName: "dollarsign.circle")
                        TextField("What's the principal?", text: self.$formPrincipal)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                }
                Section(header: ExplainationHeader(title: "Annual Interest Rate (APR)", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                    HStack{
                        TextField("What's the annual interest rate (APR)?", text: self.$formInterestRate)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
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
                                    .keyboardType(.decimalPad)
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
                                    .keyboardType(.numberPad)
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
                self.termMonths = Int(self.formTermMonths) ?? 0
                
                let calculator = MonthlyPaymentWhatIf(principal: principal, interestRate: interestRate, months: self.termMonths)
                self.monthlyPayments = calculator.monthlyPayment()
                self.totalInterest = calculator.totalInterest()
                self.showAnswer = true
                
                if self.interstitial.isReady {
                    let root = UIApplication.shared.windows.first?.rootViewController
                    self.interstitial.present(fromRootViewController: root!)
                }
                else {
                    print("Not Ready")
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
                        Text("Term:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("\(self.termMonths)")
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
                        Text("$\(self.monthlyPayments, specifier: self.valueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                    HStack{
                        Text("Total Interest:")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                        Spacer()
                        Text("$\(self.totalInterest, specifier: self.valueSpec)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(3)
                    }
                }.padding()
            }
        }.animation(.linear(duration: 0.3))
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Monthly Payment")
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.blue)
        .onTapGesture {
            self.endEditing(true)
        }
        .onAppear {
            self.interstitial =  GADInterstitial(adUnitID: self.adID)
            let req = GADRequest()
            self.interstitial.load(req)
        }
    }
}

struct MonthlyPayment_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPayment()
    }
}
