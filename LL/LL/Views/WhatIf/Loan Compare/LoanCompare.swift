//
//  LoanCompare.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

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
                //}
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
                            self.loan.interest = Double(self.formInterestRate) ?? nil
                            self.loan.months = Int(self.formTermMonths) ?? nil
                        }
                    }
            }
            
        }
    }
}

struct LoanCompare_Previews: PreviewProvider {
    static var previews: some View {
        LoanCompare(loan: LoanItem(id: UUID(), name: 1, interest: 5, months: 3), setToCalculate: .constant(false), incomplete: .constant(true))
    }
}
