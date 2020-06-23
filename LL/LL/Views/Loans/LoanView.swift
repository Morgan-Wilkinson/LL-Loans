//
//  LoanView.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import CoreData
import GoogleMobileAds

struct LoanView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
    
    // Ads
    var AdControl: Ads = Ads()
    
    @State var showingAdder = false
    @State var showAdNow = false
    let dateFormatter = DateFormatter()
    let ipadPadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0
    
    init() {
        self.AdControl = Ads()
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMMM d, y"
    }
    
    var body: some View {
        
        let footerText = self.loans.count != 0 ? "Here are your loans as of \(self.dateFormatter.string(from: Date()))." : "You're not tracking any loans, add some."
        
        return NavigationView {
            List{
                Section(header: SectionHeaderView(text: "Loan Records", icon: "doc.text"), footer: Text(footerText)) {
                        if self.loans.count > 0 {
                            ForEach(self.loans, id: \.self) { loan in
                                VStack {
                                    if !loan.willDelete {
                                         NavigationLink(destination: LoanDetail(loan: loan)) {
                                             SimpleRow(name: loan.name, loanType: loan.typeOfLoan,
                                             origin: loan.origin, startDate: loan.startDate,
                                             dueAmount: loan.regularPayments)
                                         }
                                   }
                                    else {
                                        Button(action: {self.restoreDeletedLoan(loan: loan)}) {
                                            Text("Restore \(loan.name)")
                                                .fontWeight(.medium)
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.accentColor)
                                                .padding(5)
                                                
                                        }
                                    }
                                }
                            }.onDelete(perform: self.prepDelete)
                    }
                }
                
                Section {
                    Button(action: {
                        self.showingAdder.toggle()
                    }) {
                        Text("New Loan")
                            .fontWeight(.bold)
                            .font(.title)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.bigButtonText)
                            .padding(5)
                    }.listRowBackground(Color.bigButton)
                    .sheet(isPresented: $showingAdder, onDismiss: {
                        self.AdControl.showAd()
                    }) {
                        LoanAdder(showingSheet: self.$showingAdder, showAdNow: self.$showAdNow).environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
                
            }.listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(Text("Loans"))
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAdder.toggle()}){
                HStack{
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.medium)
                    Text("Loan")
                }
            }
            // Loan Adder
            .sheet(isPresented: self.$showingAdder, onDismiss: {
                self.AdControl.showAd()
            }) {
                LoanAdder(showingSheet: self.$showingAdder, showAdNow: self.$showAdNow).environment(\.managedObjectContext, self.managedObjectContext)
            })
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding(.leading, ipadPadding)
    }
    
    func restoreDeletedLoan(loan: Loans) {
        loan.willDelete = false
        
        try? self.managedObjectContext.save()
        
        self.AdControl.showAd()
    }
    
    /// DELET f
    /// - Parameter offsets: This is a test
    func prepDelete(at offsets: IndexSet) {
        for offset in offsets {
            // find this loan in our fetch request
            let loan = self.loans[offset]
            
            loan.willDelete = true
        }
        try? self.managedObjectContext.save()
    }
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Test data
        return LoanView().environment(\.managedObjectContext, context)
    }
}
