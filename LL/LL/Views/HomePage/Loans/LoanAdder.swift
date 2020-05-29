//
//  LoanAdder.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import CoreData

struct LoanAdder: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // Form Fields
    @State private var loanTitle = ""
    @State private var origin = ""
    @State private var principal = ""
    @State private var interestRate = ""
    @State private var termYears = ""
    @State private var termMonths = ""
    @State private var about = ""
    @State private var currentDueDate = Date()
    @State private var nextDueDate = Date()
    @State private var startDate = Date()
    @State private var remainingMonths = Date()
    @State private var selectedLoanType = 0
    @State private var typeOfLoan = ["Mortgage", "Car | Auto", "Personal", "Student", "Installment"]
    
    // Pickers
    @State private var loanPickerVisible = false
    @State private var startDatePickerVisible = false
    @State private var currentDatePickerVisible = false
    
    // Styling Formatter
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    // Form Data Checker
    var disableForm: Bool {
        loanTitle.isEmpty || principal.isEmpty || interestRate.isEmpty || (termMonths.isEmpty && termYears.isEmpty) || principal == "0" || interestRate == "0" || (termMonths == "0" && termYears == "0")
    }
    
    init() {
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "d MMM y"
    }
    
    var body: some View {
        return List {
            Group{
                Section(header: ExplainationHeader(title: "Loan Name", nameIcon: "doc.text", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                    TextField("Loan Name", text: self.$loanTitle)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.top, .bottom, .trailing])
                        .cornerRadius(5)
                }
                
                Section(header: ExplainationHeader(title: "Origin", nameIcon: "globe", moreInfoIcon: "questionmark.circle", explanation: "Where is the loan from?")){
                    TextField("Loan Origin", text: self.$origin)
                    .textFieldStyle(PlainTextFieldStyle())
                        .padding([.top, .bottom, .trailing])
                    .cornerRadius(5)
                }
            }
            
            // Loan type picker
            Group{
                Section(header: ExplainationHeader(title: "Loan Type", nameIcon: "square.stack.fill")){
                    HStack{
                        Text("Loan Type")
                        Spacer()
                        Button(typeOfLoan[self.selectedLoanType]) {
                            self.loanPickerVisible.toggle()
                        }
                    }.padding(.vertical)
                    
                    if self.loanPickerVisible{
                        Picker(selection: $selectedLoanType, label: Text("Loan Type")) {
                            ForEach(0 ..< typeOfLoan.count) {
                                Text(self.typeOfLoan[$0])
                            }
                        }.pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        .onTapGesture {
                            self.loanPickerVisible.toggle()
                        }
                    }
                }
            }
            
            Group{
                Section(header: ExplainationHeader(title: "Principal", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                    HStack{
                        Spacer()
                        Image(systemName: "dollarsign.circle")
                        TextField("What's the principal?", text: self.$principal)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.top, .bottom, .trailing])
                            .cornerRadius(5)
                    }
                }
                Section(header: ExplainationHeader(title: "Annual Interest Rate (APR)", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                    HStack{
                        TextField("What's the annual interest rate (APR)?", text: self.$interestRate)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.top, .bottom, .trailing])
                            .cornerRadius(5)
                        Image(systemName: "percent")
                        Spacer()
                    }
                }
            }
            
            Group{
                Section(header: ExplainationHeader(title: "Term", nameIcon: "hourglass.bottomhalf.fill", moreInfoIcon: "questionmark.circle", explanation: "Enter the loan's terms in either years, months or both!")){
                    HStack{
                        ZStack{
                            HStack{
                                TextField("Years", text: self.$termYears)
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
                                TextField("Months", text: self.$termMonths)
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
            Group{
                Section(header: ExplainationHeader(title: "Loan Start Date", nameIcon: "calendar.circle")) {
                    // Start Date picker
                    HStack{
                        Text("Start Date")
                        Spacer()
                        Button("\(dateFormatter.string(from: self.startDate))") {
                            self.startDatePickerVisible.toggle()
                        }
                    }.padding(.vertical)
                    if self.startDatePickerVisible {
                        DatePicker("", selection: self.$startDate, in: ...Date(), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .onTapGesture {
                                self.startDatePickerVisible.toggle()
                            }
                    }
                }
                
                Section(header: ExplainationHeader(title: "Loan Payment Date", nameIcon: "calendar.circle")){
                    // Current Due Date Picker
                    HStack{
                        Text("Due Date")
                        Spacer()
                        Button("\(dateFormatter.string(from: self.currentDueDate))") {
                            self.currentDatePickerVisible.toggle()
                        }
                    }.padding(.vertical)
                    if self.currentDatePickerVisible {
                        DatePicker("", selection: self.$currentDueDate, in: ...Date(), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .onTapGesture {
                                self.currentDatePickerVisible.toggle()
                            }
                    }
                }
            }
            
            Group{
                Section(header: ExplainationHeader(title: "Description", nameIcon: "text.bubble")){
                    ZStack{
                        MultilineTextField("Description", text: self.$about)
                            .padding()
                    }
                }
            }
        }.environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("New Loan")
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.blue)
        .navigationBarItems(
        trailing: Button(action: ({
        // Save the items. All items have a default value that should actually be used.
        if self.termYears.isEmpty == false {
            let months = self.numberFormatter.number(from: self.termMonths) ?? 0
            let years = self.numberFormatter.number(from: self.termYears) ?? 0
            
            self.termMonths = "\((Int(truncating: years) * 12) + Int(truncating: months))"
        }
        let loanSaver = Loans(context: self.managedObjectContext)
        //loanSaver.id = UUID()
        loanSaver.name = self.loanTitle
        loanSaver.origin = self.origin
        loanSaver.typeOfLoan = self.typeOfLoan[self.selectedLoanType]
        loanSaver.originalPrincipal = self.numberFormatter.number(from: self.principal) ?? 0
        loanSaver.interestRate = self.numberFormatter.number(from: self.interestRate) ?? 0
        loanSaver.about = self.about
        loanSaver.termMonths = self.numberFormatter.number(from: self.termMonths) ?? 0
        loanSaver.startDate = self.startDate
        loanSaver.currentDueDate = Calendar.current.startOfDay(for: self.currentDueDate)
        
        // Data calculators
        let paymentsCalculator = PaymentsCal(loan: loanSaver)
        let smallMonthsCalculator = SmallMonthsCal(loan: loanSaver)
        // Fill in the rest of the values
        // Fill the Loan object with the big arrays data
        paymentsCalculator.runner()
        // Fill the Loan object with the small arrays data
        smallMonthsCalculator.runner()
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Failed")
        }
            self.mode.wrappedValue.dismiss()
        }))
        {
            HStack{
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .imageScale(.medium)
                Text("Save")
            }
        }.disabled(disableForm))
        .keyboardAdaptive() // Fix white padding box
    }
}

struct LoanAdder_Previews: PreviewProvider {
    static var previews: some View {
        LoanAdder()
    }
}
