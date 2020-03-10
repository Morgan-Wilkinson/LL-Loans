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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var loan: Loans
    let formatter = NumberFormatter()
    let components = DateComponents()
    
    @State private var loanTitle: String
    @State private var principal: String
    @State private var regularPayments: String
    @State private var interestRate: String
    @State private var termMonths: String
    @State private var about: String
    @State private var currentDueDate: Date
    @State private var nextDueDate: Date
    @State private var prevDueDate: Date
    @State private var startDate: Date
    @State private var remainingMonths: Date
    @State private var selectedLoanType = 0
    @State private var typeOfLoan = ["Mortgage", "Refinance", "Home Equity", "Car | Auto", "Personal", "Business", "Student", "Installment", "Payday", "Debt Consolidation"]
    
    init(loan: Loans) {
      self.loan = loan
        self._loanTitle = State(initialValue: loan.name)
        self._principal = State(initialValue: "\(loan.originalPrincipal)")
        self._regularPayments = State(initialValue: "\(loan.regularPayments)")
        self._interestRate = State(initialValue: "\(loan.interestRate)")
        self._termMonths = State(initialValue:"\(loan.termMonths)")
        self._about = State(initialValue: loan.about)
        self._currentDueDate = State(initialValue: loan.currentDueDate)
        self._nextDueDate = State(initialValue: loan.nextDueDate)
        self._prevDueDate = State(initialValue: loan.prevDueDate)
        self._startDate = State(initialValue: loan.startDate)
        self._remainingMonths = State(initialValue: Date())
        
        let i = self.typeOfLoan.firstIndex(where: { $0.hasPrefix("\(loan.typeOfLoan)")})
        self._selectedLoanType = State(initialValue: i ?? 0)
        
    }
    
    var disableForm: Bool {
        loanTitle.isEmpty || principal.isEmpty || interestRate.isEmpty || termMonths.isEmpty
    }
    
    var body: some View {
            VStack {
                Form {
                    Section{
                        TextField("Loan Name", text: self.$loanTitle)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Section {
                        Picker(selection: $selectedLoanType, label: Text("Loan Type")) {
                            ForEach(0 ..< typeOfLoan.count) {
                                Text(self.typeOfLoan[$0])
                            }
                        }
                    }
                    Section{
                        TextField("What's the principal?", text: self.$principal)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                        TextField("What's the interest rate?", text: self.$interestRate)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    Section{
                        TextField("What's the term in months?", text: self.$termMonths)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                        DatePicker(selection: self.$startDate, in: ...Date(), displayedComponents: .date)
                        {
                            Text("When did the terms of this loan begin?")
                        }
                        DatePicker(selection: self.$currentDueDate, in: ...Date(), displayedComponents: .date)
                        {
                            Text("When is your payment this month due?")
                        }
                        TextField("How much do you plan to pay each month?", text: self.$regularPayments)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    Section{
                        TextField("Description", text: self.$about)
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(nil)
                    }
                    
                    Button(action: ({
                         self.loan.id = UUID()
                         self.loan.name = self.loanTitle
                         self.loan.typeOfLoan = self.typeOfLoan[self.selectedLoanType]
                         self.loan.originalPrincipal = self.formatter.number(from: self.principal) ?? 0
                         self.loan.currentPrincipal = self.formatter.number(from: self.principal) ?? 0
                         self.loan.interestRate = self.formatter.number(from: self.interestRate) ?? 0
                         self.loan.about = self.about
                         self.loan.termMonths = self.formatter.number(from: self.termMonths) ?? 0
                         self.loan.startDate = self.startDate
                         self.loan.currentDueDate = Calendar.current.startOfDay(for: self.currentDueDate)
                         self.loan.nextDueDate = Calendar.current.nextDate(after: self.currentDueDate, matching: (Calendar.current.dateComponents([.day], from: self.currentDueDate)), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) ?? Date()
                         self.loan.prevDueDate = Calendar.current.nextDate(after: self.currentDueDate, matching: (Calendar.current.dateComponents([.day], from: self.currentDueDate)), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward) ?? Date()
                     do {
                         try self.managedObjectContext.save()
                     } catch {
                         print("Failed")
                     }})) {
                         HStack{
                             Image(systemName: "plus.circle.fill")
                                 .foregroundColor(.blue)
                                 .imageScale(.medium)
                             Text("Save")
                         }
                    }
                }
        }.navigationBarTitle("Loan Editor")
        }
}
