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
    
    let formatter = NumberFormatter()
    var components = DateComponents()
    @State private var loanTitle = ""
    @State private var origin = ""
    @State private var principal = ""
    @State private var interestRate = ""
    @State private var termMonths = ""
    @State private var about = ""
    @State private var currentDueDate = Date()
    @State private var nextDueDate = Date()
    @State private var prevDueDate = Date()
    @State private var startDate = Date()
    @State private var remainingMonths = Date()
    @State private var selectedLoanType = 0
    @State private var typeOfLoan = ["Mortgage", "Refinance", "Home Equity", "Car | Auto", "Personal", "Business", "Student", "Installment", "Payday", "Debt Consolidation"]
    
    @State private var loanPickerVisible = false
    @State private var startDatePickerVisible = false
    @State private var currentDatePickerVisible = false
    
    var disableForm: Bool {
        loanTitle.isEmpty || principal.isEmpty || interestRate.isEmpty || termMonths.isEmpty
    }
    
    init(){
        // Remove form upper and lower space
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
        UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    }

    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM y"
        
        return List {
            VStack {
                Section{
                    TextField("Loan Name", text: self.$loanTitle)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                    TextField("Loan Origin", text: self.$origin)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.all)
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    .cornerRadius(5)
                }
                
                // Loan type picker
                ZStack{
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.white)
                    VStack{
                        HStack{
                            Text("Loan Type")
                            Spacer()
                            Button(typeOfLoan[self.selectedLoanType]) {
                                self.loanPickerVisible.toggle()
                            }
                        }
                        
                        if self.loanPickerVisible{
                            HStack{
                                Spacer()
                                Picker(selection: $selectedLoanType, label: Text("Loan Type")) {
                                    ForEach(0 ..< typeOfLoan.count) {
                                        Text(self.typeOfLoan[$0])
                                    }
                                }
                                .labelsHidden()
                                .onTapGesture {
                                    self.loanPickerVisible.toggle()
                                }
                                Spacer()
                            }
                        }
                    }.padding()
                }.shadow(radius: 10)
                
                
                
                Section{
                    TextField("What's the principal?", text: self.$principal)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                    
                    TextField("What's the annual interest rate? E.g 9%, 5.5%", text: self.$interestRate)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                    
                    TextField("What's the term in months?", text: self.$termMonths)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                }
                
                ZStack{
                   RoundedRectangle(cornerRadius: 5, style: .continuous)
                   .fill(Color.white)
                    VStack{
                        // Start Date picker
                        HStack{
                            Text("Start Date")
                            Spacer()
                            Button("\(formatter.string(from: self.startDate))") {
                                self.startDatePickerVisible.toggle()
                            }
                        }
                        if self.startDatePickerVisible {
                            HStack{
                                Spacer()
                                DatePicker("", selection: self.$startDate, in: ...Date(), displayedComponents: .date)
                                .labelsHidden()
                                .onTapGesture {
                                    self.startDatePickerVisible.toggle()
                                }
                                Spacer()
                            }
                        }
                    }.padding()
                }.shadow(radius: 10)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.white)
                     VStack{
                        // Current Due Date Picker
                        HStack{
                            Text("Current Due Date")
                            Spacer()
                            Button("\(formatter.string(from: self.currentDueDate))") {
                                self.currentDatePickerVisible.toggle()
                            }
                        }
                        if self.currentDatePickerVisible {
                            HStack{
                                Spacer()
                                DatePicker("", selection: self.$currentDueDate, in: ...Date(), displayedComponents: .date)
                                .labelsHidden()
                                .onTapGesture {
                                    self.currentDatePickerVisible.toggle()
                                }
                                Spacer()
                            }
                        }
                    }.padding()
                }.shadow(radius: 10)
                
                Section{
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                        MultilineTextField("Description", text: self.$about)
                            .padding()
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                }
                
            }.buttonStyle(PlainButtonStyle())
            .padding(.vertical)
            .foregroundColor(Color.blue)
            .background(Color.white)
            .navigationBarItems(
            trailing: Button(action: ({
                
            // Save the items. All items have a default value that should actually be used.
            let loanSaver = Loans(context: self.managedObjectContext)
            loanSaver.id = UUID()
            loanSaver.name = self.loanTitle
            loanSaver.origin = self.origin
            loanSaver.typeOfLoan = self.typeOfLoan[self.selectedLoanType]
            loanSaver.originalPrincipal = self.formatter.number(from: self.principal) ?? 0
            loanSaver.currentPrincipal = self.formatter.number(from: self.principal) ?? 0
            loanSaver.interestRate = self.formatter.number(from: self.interestRate) ?? 0
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
                self.mode.wrappedValue.dismiss()
            })) {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.medium)
                        Text("Save")
                    }
                }.disabled(disableForm))
            .navigationBarTitle("New Loan")
        }
    }
}

struct LoanAdder_Previews: PreviewProvider {
    static var previews: some View {
        LoanAdder()
    }
}
