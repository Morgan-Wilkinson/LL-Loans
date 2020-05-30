//
//  LoanEditor.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/9/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import CoreData

struct LoanEditor: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode
    
    // Form Fields
    @State private var loanTitle: String
    @State private var origin: String
    @State private var principal: String
    @State private var interestRate: String
    @State private var termYears = ""
    @State private var termMonths: String
    @State private var about: String
    @State private var currentDueDate: Date
    @State private var startDate: Date
    @State private var selectedLoanType = 0
    @State private var typeOfLoan = ["Mortgage", "Car | Auto", "Personal", "Student", "Installment"]
    
    // Pickers
    @State private var loanPickerVisible = false
    @State private var startDatePickerVisible = false
    @State private var currentDatePickerVisible = false
    
    // Styling Formatters
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    // Loan Object
    @ObservedObject var loan: Loans
    
    // Form Data Checker
    var disableForm: Bool {
        loanTitle.isEmpty || principal.isEmpty || interestRate.isEmpty || (termMonths.isEmpty && termYears.isEmpty) || principal == "0" || interestRate == "0" || (termMonths == "0" && termYears == "0")
    }
    
    init(loan: Loans) {
        self.loan = loan
        self._loanTitle = State(initialValue: loan.name)
        self._origin = State(initialValue: loan.origin)
        self._principal = State(initialValue: "\(loan.originalPrincipal)")
        self._interestRate = State(initialValue: "\(loan.interestRate)")
        self._termMonths = State(initialValue:"\(loan.termMonths)")
        self._about = State(initialValue: loan.about)
        self._currentDueDate = State(initialValue: loan.currentDueDate)
        self._startDate = State(initialValue: loan.startDate)
        
        let i = self.typeOfLoan.firstIndex(where: { $0.hasPrefix("\(loan.typeOfLoan)")})
        self._selectedLoanType = State(initialValue: i ?? 0)
        
        // Date format
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "d MMM y"
    }
    
    var body: some View {
        
        return NavigationView {
            List {
                Group{
                    Section(header: ExplainationHeader(title: "Loan Name", nameIcon: "doc", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        TextField("Loan Name", text: self.$loanTitle)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    
                    Section(header: ExplainationHeader(title: "Origin", nameIcon: "globe", moreInfoIcon: "questionmark.circle", explanation: "Where is the loan from?")){
                        TextField("Loan Origin", text: self.$origin)
                        .textFieldStyle(PlainTextFieldStyle())
                    }
                }
                // Loan type picker
                Group{
                    Section(header: ExplainationHeader(title: "Loan Type", nameIcon: "square.stack.fill")) {
                        HStack{
                            Text("Loan Type")
                            Spacer()
                            Button(typeOfLoan[self.selectedLoanType]) {
                                self.loanPickerVisible.toggle()
                            }
                        }
                        
                        if self.loanPickerVisible{
                            Picker(selection: $selectedLoanType, label: Text("Loan Type")) {
                                ForEach(0 ..< typeOfLoan.count) {
                                    Text(self.typeOfLoan[$0])
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
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
                                .keyboardType(.decimalPad)
                        }
                    }
                    Section(header: ExplainationHeader(title: "Annual Interest Rate (APR)", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        HStack{
                            TextField("What's the annual interest rate (APR)?", text: self.$interestRate)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.decimalPad)
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
                                        .keyboardType(.numberPad)
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
                                        .keyboardType(.numberPad)
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
                        }
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
                        }
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
                        MultilineTextField("Description", text: self.$about)
                    }
                }
            }
            .animation(.linear(duration: 0.3))
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .buttonStyle(PlainButtonStyle())
            .modifier(AdaptsToSoftwareKeyboard())
            .foregroundColor(Color.blue)
            .navigationBarItems(
                trailing: Button(action: ({
                // Save the items. All items have a default value that should actually be used.
                if self.termYears.isEmpty == false {
                    let months = self.numberFormatter.number(from: self.termMonths) ?? 0
                    let years = self.numberFormatter.number(from: self.termYears) ?? 0
                    
                    self.termMonths = "\((Int(truncating: years) * 12) + Int(truncating: months))"
                }
                self.loan.name = self.loanTitle
                self.loan.origin = self.origin
                self.loan.typeOfLoan = self.typeOfLoan[self.selectedLoanType]
                self.loan.originalPrincipal = self.numberFormatter.number(from: self.principal) ?? 0
                self.loan.interestRate = self.numberFormatter.number(from: self.interestRate) ?? 0
                self.loan.about = self.about
                self.loan.termMonths = self.numberFormatter.number(from: self.termMonths) ?? 0
                self.loan.startDate = self.startDate
                self.loan.currentDueDate = Calendar.current.startOfDay(for: self.currentDueDate)
                    
                // Data calculators
                let paymentsCalculator = PaymentsCal(loan: self.loan)
                let smallMonthsCalculator = SmallMonthsCal(loan: self.loan)
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
                    self.presentationMode.wrappedValue.dismiss()
                }))
                {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.medium)
                        Text("Save")
                    }
                }.disabled(disableForm))
            .navigationBarTitle("Editor", displayMode: .inline)
            .onTapGesture {
                self.endEditing(true)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

/* Time calculator for previous month

 self.loan.prevDueDate = Calendar.current.nextDate(after: self.currentDueDate, matching: (Calendar.current.dateComponents([.day], from: self.currentDueDate)), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward) ?? Date()
*/
