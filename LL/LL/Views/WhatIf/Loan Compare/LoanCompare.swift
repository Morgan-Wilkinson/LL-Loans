//
//  LoanCompare.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//
// Use the class MonthlyPayment 
import SwiftUI
import GoogleMobileAds

struct LoanCompare: View {
    @ObservedObject var loan: LoanItem
    @Binding var setToCalculate: Bool
    @Binding var incomplete: Bool
    // Ads
    var AdControl: Ads = Ads()
    
    let ipadDevice = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    @State private var formInterestRate = ""
    @State private var formTermYears = ""
    @State private var formTermMonths = ""

    let valueSpec: String = "%.2f"
    let formatter = NumberFormatter()
    
    // Make a binding
    var disableForm: Bool {
        formInterestRate.isEmpty || (formTermYears.isEmpty && formTermMonths.isEmpty) || formInterestRate == "0" || (formTermYears == "0" && formTermMonths == "0")
    }
    var body: some View {
        return Group {
            Group{
                ZStack {
                    HStack{
                        Text("APR")
                            .fontWeight(.bold)
                        Divider()
                        TextField("What's the annual interest rate (APR)?", text: self.$formInterestRate)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                        Image(systemName: "percent")
                        Spacer()
                    }
                }
            }
            Group{
                HStack{
                    ZStack{
                        HStack{
                            TextField("Years", text: self.$formTermMonths)
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
                            TextField("Months", text: self.$formTermYears)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                            Text("Months")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            
            if setToCalculate && disableForm {
                Text("Incomplete!")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .onAppear {
                        self.incomplete = true
                    }
                .onDisappear{
                    self.incomplete = false
                }
            }
            if !disableForm{
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.seal")
                        .foregroundColor(.blue)
                        .imageScale(.medium)
                        .onAppear {
                            self.loan.interest = Double(self.formInterestRate) ?? 0
                            self.loan.years = Double(self.formTermYears) ?? 0
                            self.loan.months = Int(self.formTermMonths) ?? 0
                        }
                    }
            }
            
        }
    }
}

struct LoanCompare_Previews: PreviewProvider {
    static var previews: some View {
        LoanCompare(loan: LoanItem(id: UUID(), name: 1, interest: 5, years: 12, months: 3), setToCalculate: .constant(false), incomplete: .constant(true))
    }
}

/*
 if self.formTermYears.isEmpty == false {
                            let months = self.formatter.number(from: self.formTermMonths) ?? 0
                            let years = self.formatter.number(from: self.formTermYears) ?? 0
                            
                            self.formTermMonths = "\((Int(truncating: years) * 12) + Int(truncating: months))"
                            self.formTermYears = ""
                            
                        }
 */
