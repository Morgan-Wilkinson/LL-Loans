//
//  Dashboard.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/15/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct Dashboard: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
    
    let dateFormatter = DateFormatter()
    var today: Date = Date()
    
    init(){
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "EEEE, MMM d"
    }
    
    var body: some View {
        var totalMonthlyCost: Double = 0
        var totalPrincipal: Double = 0
        var totalInterest: Double = 0
        var dueSoon: [Loans] = []
        var dueDate: [String] = []
        
        // Highest Interest Rate
        var highestInterestRate: Double = 0
        var highestInterestRateName = ""
        
        // Highest Cash Interest
        var highestCashInterest: Double = 0
        var highestCashInterestName = ""
        
        if self.loans.count > 0 {
            // Highest Interest Rate
            highestInterestRate = Double(truncating: self.loans[0].interestRate)
            highestInterestRateName = self.loans[0].name
            
            // Highest Cash Interest
            highestCashInterest = self.loans[0].interestTotalsArray.last ?? 0
            highestCashInterestName = self.loans[0].name
            
            for i in self.loans {
                // Total mothly cost
                totalMonthlyCost += i.regularPayments
                // Principal
                totalPrincipal += Double(truncating: i.originalPrincipal)
                totalInterest += i.interestTotalsArray.last ?? 0
                
                // Upcoming payments
                let loanDay = Calendar.current.dateComponents([.day], from: i.startDate).day!
                let currentDay = Calendar.current.dateComponents([.day], from: Date()).day!
                let daysLeft = loanDay - currentDay
                if daysLeft <= 5  && daysLeft >= 0 {
                    dueSoon.append(i)
                    
                    // Due Dates
                    let currentMonthIndex = Calendar.current.dateComponents([.month, .day], from: i.startDate, to: Date()).month!
                    dueDate.append(dateFormatter.string(from: (Calendar.current.date(byAdding: .month, value: currentMonthIndex + 1, to: i.startDate)!)))
                }
                // Highest interest rate
                let potentialHighIntR = Double(truncating: i.interestRate)
                let potentialHighNameR = i.name
                
                if highestInterestRate < potentialHighIntR {
                    highestInterestRate = potentialHighIntR
                    highestInterestRateName = potentialHighNameR
                }
                
                // Highest interest Cash value
                let potentialCashHighInt = i.interestTotalsArray.last ?? 0
                let potentialCashHighName = i.name
                
                if highestCashInterest < potentialCashHighInt {
                    highestCashInterest = potentialCashHighInt
                    highestCashInterestName = potentialCashHighName
                }
                
            }
        }
        
        return NavigationView{
            List {
                Section(header: SectionHeaderView(text: "Number of Loans", icon: "number.square")) {
                    Text("You have \(self.loans.count) loans to be paid off.")
                }
                if self.loans.count > 0 {
                    // Upcoming Loans
                    if !dueSoon.isEmpty {
                        Section(header: SectionHeaderView(text: "Upcoming Loan Payments", icon: "calendar")) {
                            ForEach(dueSoon.indices) { i in
                                VStack {
                                    HStack {
                                        Text("\(dueSoon[i].name)")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        Text("$\(dueSoon[i].regularPayments, specifier: "%.2f")")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.leading)
                                    }
                                    HStack{
                                        Text("Due Date:")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        Text("\(dueDate[i])")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        }
                    }
                    // Total Monthly Cost
                    Section(header: SectionHeaderView(text: "Total Monthly Cost", icon: "dollarsign.square")) {
                        HStack{
                        Text("Total Monthly Cost")
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        Text("$\(totalMonthlyCost, specifier: "%.2f")")
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        }
                    }
                    
                    // End of Month Balances
                    Section(header: SectionHeaderView(text: "End of Month Balances", icon: "sunset")) {
                        ForEach(self.loans.indices, id: \.self) { i in
                            HStack{
                                Text("\(self.loans[i].name)")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if Calendar.current.dateComponents([.month, .day], from: self.loans[i].startDate, to: Date().endOfMonth).month! > 0 {
                                    Text("$\(self.loans[i].balanceArray[Calendar.current.dateComponents([.month, .day], from: self.loans[i].startDate, to: Date().startOfMonth).month!], specifier: "%.2f")")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                }
                                else {
                                    Text("$\(self.loans[i].regularPayments * Double(truncating: self.loans[i].termMonths), specifier: "%.2f")")
                                    .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                    
                    Section(header: SectionHeaderView(text: "Highlights", icon: "sparkles")) {
                        // Highest Interest Rate
                        VStack{
                            HStack{
                                Text("Highest Interest Rate:")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text(highestInterestRateName)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                            }
                            HStack {
                                Text("Rate:")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text("\(highestInterestRate, specifier: "%.2f")%")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        // Highest Cash Interest
                        VStack{
                            HStack{
                                Text("Highest Cash Interest:")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text(highestCashInterestName)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                            }
                            HStack {
                                Text("Cash Amount:")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text("$\(highestCashInterest, specifier: "%.2f")")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                    }
                    
                    // Total Prinicipal
                    Section(header: SectionHeaderView(text: "Total Principal", icon: "dollarsign.square")) {
                        Text("Your total principal for all your loans is $\(totalPrincipal, specifier: "%.2f")")
                            .lineLimit(nil)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                    // Total Interest
                    Section(header: SectionHeaderView(text: "Total Interest", icon: "dollarsign.square")) {
                        Text("Your total interest for all your loans is $\(totalInterest, specifier: "%.2f")")
                            .lineLimit(nil)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text(dateFormatter.string(from: Date())))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Dashboard().environment(\.managedObjectContext, context)
    }
}
