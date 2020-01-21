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
    let formatter = NumberFormatter()
    var components = DateComponents()
    @State private var loanTitle = ""
    @State private var principal = ""
    @State private var regularPayments = ""
    @State private var interestRate = ""
    @State private var termMonths = ""
    @State private var about = ""
    
    @State private var currentDueDate = Date()
    @State private var nextDueDate = Date()
    @State private var prevDueDate = Date()
    @State private var startDate = Date()
    @State private var remainingMonths = Date()
    
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
                }.navigationBarItems(
                trailing: Button(action: ({
                    
                // Save the items. All items have a default value that should actually be used.
                let loanSaver = Loans(context: self.managedObjectContext)
                loanSaver.id = UUID()
                loanSaver.name = self.loanTitle
                loanSaver.originalPrincipal = self.formatter.number(from: self.principal) ?? 0
                loanSaver.currentPrincipal = self.formatter.number(from: self.principal) ?? 0
                loanSaver.interestRate = self.formatter.number(from: self.interestRate) ?? 0
                    loanSaver.regularPayments = self.formatter.number(from: self.regularPayments) ?? 0
                loanSaver.about = self.about
                    
                loanSaver.termMonths = self.formatter.number(from: self.termMonths) ?? 0
                loanSaver.startDate = self.startDate
                loanSaver.currentDueDate = Calendar.current.startOfDay(for: self.currentDueDate)
                loanSaver.nextDueDate = Calendar.current.nextDate(after: self.currentDueDate, matching: (Calendar.current.dateComponents([.day], from: self.currentDueDate)), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) ?? Date()
                loanSaver.prevDueDate = Calendar.current.nextDate(after: self.currentDueDate, matching: (Calendar.current.dateComponents([.day], from: self.currentDueDate)), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward) ?? Date()
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Failed")
                }
                })) {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.medium)
                        Text("Save")
                    }
                    }.disabled(disableForm))
            }
        }
    //func checkFilledForm
}

struct LoanAdder_Previews: PreviewProvider {
    static var previews: some View {
        LoanAdder()
    }
}
