//
//  CompoundInterestCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/21/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct CompoundInterest: View {
    @State private var formPrincipal = ""
    @State private var formInterestRate = ""
    @State private var formTermYears = ""
    @State private var formTermMonths = ""
    
    @State private var accuredAmmount: Double = 0
    @State private var principal: Double = 0
    @State private var totalInterest: Double = 0
    @State private var years: Double = 0
    
    @State private var showAnswer: Bool = false
    
    @State private var selectedCompoundType = 0
    @State private var typeOfCompoundInterestString = ["Daily 365/Yr", "Daily 360/Yr", "Weekly 52/Yr", "Bi-Weekly 26/Yr", "Semi-Monthly 24/Yr", "Monthly 12/Yr", "Bi-Monthly 6/Yr", "Quarterly 4/Yr", "Semi-Annually 2/Yr", "Annually 1/Yr"]
    @State private var typeOfCompoundInterestDouble: [Double] = [365.0, 360.0, 52.0, 26.0, 24.0, 12.0, 6.0, 4.0, 2.0, 1.0]
    
    // Pickers
    @State private var compoundInterestPickerVisible = false
    
    let valueSpec: String = "%.2f"
    let textBoxColor = Color("TextFieldBox")
    let cardColor = Color("Cards")
    let bigButtonText = Color("BigButtonText")
    let bigButtonColor = Color("BigButtonColor")
    let formatter = NumberFormatter()
    
    var disableForm: Bool {
        formPrincipal.isEmpty || formInterestRate.isEmpty ||
            formTermYears.isEmpty || formPrincipal == "0" || formInterestRate == "0" || formTermYears == "0"
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
                    Section(header: ExplainationHeader(title: "Interest Rate", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required")){
                        HStack{
                            TextField("What's the interest rate?", text: self.$formInterestRate)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.all)
                                .cornerRadius(5)
                            Image(systemName: "percent")
                            Spacer()
                        }
                    }
                }
                
                Group{
                    Section(header: ExplainationHeader(title: "Compound Type", nameIcon: "clock")) {
                        ZStack{
                            VStack{
                                // Start Date picker
                                HStack{
                                    Button("\(self.typeOfCompoundInterestString[self.selectedCompoundType])") {
                                        self.compoundInterestPickerVisible.toggle()
                                    }
                                }
                                if self.compoundInterestPickerVisible {
                                    HStack{
                                        Spacer()
                                        Picker(selection: self.$selectedCompoundType, label: Text("Strength")) {
                                            ForEach(0 ..< typeOfCompoundInterestString.count) {
                                                Text("\(self.typeOfCompoundInterestString[$0])")

                                            }
                                        }.pickerStyle(WheelPickerStyle())
                                        .labelsHidden()
                                        .onTapGesture {
                                            self.compoundInterestPickerVisible.toggle()
                                        }
                                        Spacer()
                                    }
                                }
                            }.padding()
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
                    if !self.formTermMonths.isEmpty {
                        let months = self.formatter.number(from: self.formTermMonths) ?? 0
                        let years = self.formatter.number(from: self.formTermYears) ?? 0
                        
                        self.formTermYears = "\((Double(truncating: months) / 12) + Double(truncating: years))"
                        self.formTermMonths = ""
                    }
                    
                    self.principal = Double(self.formPrincipal) ?? 0
                    let interestRate = Double(self.formInterestRate) ?? 0
                    self.years = Double(self.formTermYears) ?? 0
                    
                    let calculator = CompoundInterestCalculator(prinicipal: self.principal, interest: interestRate, years: self.years, compoundType: self.typeOfCompoundInterestDouble[self.selectedCompoundType])
                    
                    self.accuredAmmount = calculator.getAccuredAmount()
                    self.totalInterest = self.accuredAmmount - self.principal
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
                        HStack{
                            Text("Accured Ammount:")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(3)
                            Spacer()
                            Text("\(self.accuredAmmount, specifier: self.valueSpec)")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(3)
                        }
                        HStack{
                            Text("Principal:")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(3)
                            Spacer()
                            Text("\(self.principal, specifier: self.valueSpec)")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(3)
                        }
                        HStack{
                            Text("Interest:")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(3)
                            Spacer()
                            Text("\(self.totalInterest, specifier: self.valueSpec)")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(3)
                        }
                    }.padding()
                }
            }.environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Compound Interest")
            .buttonStyle(PlainButtonStyle())
            .listStyle(GroupedListStyle())
            .foregroundColor(Color.blue)
        }
    }
}

struct CompoundInterest_Previews: PreviewProvider {
    static var previews: some View {
        CompoundInterest()
    }
}
