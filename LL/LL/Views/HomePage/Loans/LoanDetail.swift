//
//  LoanDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Combine
import SwiftUI
import GoogleMobileAds

struct LoanDetail: View{
    @Environment(\.presentationMode) var homeDismiss: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var loan: Loans
    
    @State var showingEditor = false
    
    // Ads
    @State var interstitial: GADInterstitial!
    let adID: String = "ca-app-pub-3940256099942544/4411468910"
    
    var body: some View {
        // Formatters for Date style
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MMM d, y"
        
        // The array is set to have index four be the current Month or any month less than 4.
        let threeMonthBuffer = 3
        let monthsPassed  = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date()).month!
        let currentMonth = monthsPassed > threeMonthBuffer ? threeMonthBuffer : monthsPassed
        
        let currentMonthIndex = Calendar.current.dateComponents([.month, .day], from: loan.startDate, to: Date()).month!
        let currentDueDate = dateFormatter.string(from: (Calendar.current.date(byAdding: .month, value: currentMonthIndex, to: loan.startDate)!))
        
        return GeometryReader { geometry in
            List {
                // Loan Payment at a glance.
                Section(header: SectionHeaderView(text: "Loan Summary", icon: "doc.text")) {
                    Card(subtitle: "\(self.loan.origin)", title: "\(self.loan.name) - \(self.loan.typeOfLoan) Loan", overview: "Payment for \(currentDueDate): $\(self.loan.regularPayments)",
                        briefSummary: "Principal: $\(self.loan.smallPrincipalArray[currentMonth]) \nInterest: $\(self.loan.smallInterestArray[currentMonth]) \nBalance: $\(self.loan.smallBalanceArray[currentMonth])", description: "\(self.loan.about)", month: "\(dateFormatter.string(from:self.loan.startDate))")
                }
                
                    // Charts
                Section(header: SectionHeaderView(text: "Loan History & Projections", icon: "chart.bar.fill")) {
                    // Current 12 month preview
                    BarView(title: "History & Projections", currentMonthIndex: currentMonth, loan: self.loan)
                }
                // Amortization Schedule
                Section(header: SectionHeaderView(text: "Amortization Schedule")) {
                    NavigationLink(destination: PaymentBreakdownDetail(title: "Amortization Schedule", monthlyPayment: self.loan.regularPayments, monthsSeries: self.loan.monthsSeries, barValues: self.loan.allValuesArray)) {
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
                self.interstitial =  GADInterstitial(adUnitID: self.adID)
                let req = GADRequest()
                self.interstitial.load(req)
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
            }.sheet(isPresented: self.$showingEditor, onDismiss: {
                if self.interstitial.isReady {
                    let root = UIApplication.shared.windows.first?.rootViewController
                    self.interstitial.present(fromRootViewController: root!)
                }
                else {
                    print("Not Ready")
                }
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
