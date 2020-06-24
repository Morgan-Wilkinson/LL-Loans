//
//  LoanDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Combine
import SwiftUI

struct LoanDetail: View{
    @Environment(\.presentationMode) var homeDismiss: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var loan: Loans
    
    @State var showingEditor = false
    @State var shownAd = false
    
    // Ads
    var AdControl: Ads = Ads()
    
    // Formatters for Date style
    let dateFormatter = DateFormatter()
    // The array is set to have index four be the current Month or any month less than 4.
    let threeMonthBuffer = 3
    var monthsPassed: Int
    var currentMonth: Int
    var currentMonthIndex: Int
    var currentDueDate: String
    
    init(loan: Loans) {
        self.loan = loan
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MMM d, y"
        
        monthsPassed  = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date()).month!
        currentMonth = monthsPassed > threeMonthBuffer ? threeMonthBuffer : monthsPassed
        
        currentMonthIndex = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date()).month!
        currentDueDate = dateFormatter.string(from: (Calendar.current.date(byAdding: .month, value: currentMonthIndex, to: loan.startDate)!))
        
    }
    
    var body: some View {
        return GeometryReader { geometry in
            List {
                // Loan Payment at a glance.
                Section(header: SectionHeaderView(text: "Loan Summary", icon: "doc.text")) {
                    Card(subtitle: "\(self.loan.origin)", title: "\(self.loan.name) - \(self.loan.typeOfLoan) Loan", overview: "Payment for \(self.currentDueDate): $\(self.loan.regularPayments)",
                        briefSummary: "Principal: $\(self.loan.smallPrincipalArray[self.currentMonth]) \nInterest: $\(self.loan.smallInterestArray[self.currentMonth]) \nBalance: $\(self.loan.smallBalanceArray[self.currentMonth])", description: "\(self.loan.about)", month: "\(self.dateFormatter.string(from:self.loan.startDate))")
                }
                
                    // Charts
                Section(header: SectionHeaderView(text: "Loan History & Projections", icon: "chart.bar.fill")) {
                    // Current 12 month preview
                    BarView(title: "History & Projections", currentMonthIndex: self.currentMonth, loan: self.loan)
                }
                // Amortization Schedule
                Section(header: SectionHeaderView(text: "Amortization Schedule")) {
                    NavigationLink(destination: PaymentBreakdownDetail(title: "Amortization Schedule", monthlyPayment: self.loan.regularPayments, monthsSeries: self.loan.monthsSeries, barValues: self.loan.allValuesArray, shownAd: self.$shownAd)) {
                        Text("Amortization Schedule")
                            .fontWeight(.bold)
                            .font(.headline)
                            .cornerRadius(5)
                            .foregroundColor(Color.bigButtonText)
                    }.listRowBackground(Color.bigButton)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "dataBaseChange") {
                    UserDefaults.standard.set(true, forKey: "dataBaseChange")
                    // Data calculators
                    let paymentsCalculator = PaymentsCal(loan: self.loan)
                    let smallMonthsCalculator = SmallMonthsCal(loan: self.loan)
                    // Fill in the rest of the values
                    // Fill the Loan object with the big arrays data
                    paymentsCalculator.runner()
                    // Fill the Loan object with the small arrays data
                    smallMonthsCalculator.runner()
                    do {
                        // delete it from the context
                        try self.managedObjectContext.save()
                    } catch {
                        print("Failed")
                    }
                }
                
                if !self.shownAd {
                    self.shownAd = true
                    self.AdControl.showAd()
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("\(self.loan.name.capitalizingFirstLetter())")
            .navigationBarItems(trailing: Button(action: {
                self.showingEditor.toggle()}){
                HStack{
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.medium)
                        Text("Edit")
                }
            }
            // Show Editor
            .sheet(isPresented: self.$showingEditor, onDismiss: {
                self.AdControl.showAd()
            }) {
                LoanEditor(loan: self.loan).environment(\.managedObjectContext, self.managedObjectContext)
            })
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
