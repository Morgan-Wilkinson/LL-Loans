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
    @State private var origin: String
    @State private var principal: String
    @State private var regularPayments: String
    @State private var interestRate: String
    @State private var termYears = ""
    @State private var termMonths: String
    @State private var about: String
    @State private var currentDueDate: Date
    @State private var nextDueDate: Date
    @State private var prevDueDate: Date
    @State private var startDate: Date
    @State private var remainingMonths: Date
    @State private var selectedLoanType = 0
    @State private var typeOfLoan = ["Mortgage", "Car | Auto", "Personal", "Student", "Installment"]
    
    init(loan: Loans) {
      self.loan = loan
        self._loanTitle = State(initialValue: loan.name)
        self._origin = State(initialValue: loan.origin)
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
    
    @State private var loanPickerVisible = false
        @State private var startDatePickerVisible = false
        @State private var currentDatePickerVisible = false
        
        let textBoxColor = Color("TextFieldBox")
        var disableForm: Bool {
            loanTitle.isEmpty || principal.isEmpty || interestRate.isEmpty || (termMonths.isEmpty && termYears.isEmpty)
        }
        
    /*
        init(){
            // Remove colors
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear

            // Remove form upper and lower space
            UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
        }
    */
        var body: some View {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = "d MMM y"
            
            return List {
                Group{
                    Section(header: HeaderRowColor(title: "Loan Name", nameIcon: "doc", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        TextField("Loan Name", text: self.$loanTitle)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.all)
                            .background(textBoxColor)
                            .cornerRadius(5)
                            //.padding(.bottom, 20.0)
                    }
                    
                    
                    Section(header: HeaderRowColor(title: "Origin", nameIcon: "globe", moreInfoIcon: "questionmark.circle", explanation: "Where is the loan from?")){
                        TextField("Loan Origin", text: self.$origin)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.all)
                        .background(textBoxColor)
                        .cornerRadius(5)
                    }
                }
                // Loan type picker
                Group{
                    Section(header: HeaderRowColor(title: "Loan Type", nameIcon: "square.stack.fill")) {
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
                        }.shadow(radius: 2)
                    }
                }
                
                Group{
                    Section(header: HeaderRowColor(title: "Principal", nameIcon: "dollarsign.circle", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(textBoxColor)
                            HStack{
                                Spacer()
                                Image(systemName: "dollarsign.circle")
                                TextField("What's the principal?", text: self.$principal)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .padding(.all)
                                    .background(textBoxColor)
                                    .cornerRadius(5)
                                    //.padding(.bottom, 20.0)
                            }
                        }
                    }
                    Section(header: HeaderRowColor(title: "Annual Interest Rate (APR)", nameIcon: "percent", moreInfoIcon: "exclamationmark.shield", explanation: "Required!")){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(textBoxColor)
                            HStack{
                                TextField("What's the annual interest rate (APR)?", text: self.$interestRate)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .padding(.all)
                                    .cornerRadius(5)
                                    //.padding(.bottom, 20.0)
                                Image(systemName: "percent")
                                Spacer()
                            }
                        }
                    }
                }
                Group{
                    Section(header: HeaderRowColor(title: "Term", nameIcon: "hourglass.bottomhalf.fill", moreInfoIcon: "questionmark.circle", explanation: "Enter the loan's terms in either years, months or both!")){
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(textBoxColor)
                                HStack{
                                    TextField("Years", text: self.$termYears)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .padding([.top, .leading, .bottom])
                                        .background(textBoxColor)
                                        .cornerRadius(5)
                                        //.padding(.bottom, 20.0)
                                    Text("Years")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                            Divider()
                                
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(textBoxColor)
                                HStack{
                                    TextField("Months", text: self.$termMonths)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .padding(.all)
                                        .background(textBoxColor)
                                        .cornerRadius(5)
                                        //.padding(.bottom, 20.0)
                                    Text("Months")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                Group{
                    Section(header: HeaderRowColor(title: "Loan Start Date", nameIcon: "calendar.circle")) {
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
                        }.shadow(radius: 2)
                        //.padding(.bottom, 20.0)
                    }
                    
                    Section(header: HeaderRowColor(title: "Loan Payment Date", nameIcon: "calendar.circle")){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.white)
                             VStack{
                                // Current Due Date Picker
                                HStack{
                                    Text("Due Date")
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
                        }.shadow(radius: 2)
                        //.padding(.bottom, 20.0)
                    }
                }
                
                Group{
                    Section(header: HeaderRowColor(title: "Description", nameIcon: "text.bubble")){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                            MultilineTextField("Description", text: self.$about)
                                .padding()
                                .background(textBoxColor)
                        }
                    }
                }
            }
            .navigationBarTitle("Editor")
            .buttonStyle(PlainButtonStyle())
            .listStyle(PlainListStyle())
            .padding(.bottom)
            .foregroundColor(Color.blue)
            .navigationBarItems(
                trailing: Button(action: ({
                    
                // Save the items. All items have a default value that should actually be used.
                if self.termYears.isEmpty == false {
                    let months = self.formatter.number(from: self.termMonths) ?? 0
                    let years = self.formatter.number(from: self.termYears) ?? 0
                    
                    self.termMonths = "\((Int(truncating: years) * 12) + Int(truncating: months))"
                }
                self.loan.name = self.loanTitle
                self.loan.origin = self.origin
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
        }
}
