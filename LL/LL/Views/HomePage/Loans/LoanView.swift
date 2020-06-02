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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
    
    // If the view is an ipad show the current the first loan info
    @State var isActive : Bool = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    @State private var navigationSelectionTag: Int? = 0
    @State var showingAdder = false
    
    @State var interstitial: GADInterstitial!
    let adID: String = "ca-app-pub-2030770006889815/7603128128"
    
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMMM d, y"
    }
    
    var body: some View {
        
        let footerText = self.loans.count != 0 ? "Here are your loans as of \(dateFormatter.string(from: Date()))" : "You're not tracking any loans, add some."
        
        // For Split view on ipad work around.
        let ipadPadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0
        
        return NavigationView {
                List{
                    Section(header: SectionHeaderView(text: "Loan Records", icon: "doc.text"), footer: Text(footerText)) {
                        
                        if self.loans.count > 0 {
                            ForEach(self.loans, id: \.self) { loan in
                                NavigationLink(destination: LoanDetail(loan: loan), isActive: self.$isActive) {
                                    SimpleRow(name: loan.name, loanType: loan.typeOfLoan, origin: loan.origin,
                                              startDate: loan.startDate,
                                              dueAmount: loan.regularPayments)
                                }
                                .buttonStyle(PlainButtonStyle())
                                // This will change the background to show due items
                                .listRowBackground(Calendar.current.dateComponents([.day], from: loan.startDate, to: Date()).day! <= 5 ?  Color.upcomingPayment : Color.clear)
                            }.onDelete(perform: self.deleteLoans)                     
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
                            if self.interstitial.isReady {
                                let root = UIApplication.shared.windows.first?.rootViewController
                                self.interstitial.present(fromRootViewController: root!)
                            }
                            else {
                                print("Not Ready")
                            }}) {
                            LoanAdder().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                    }
                }.onAppear {
                    self.interstitial =  GADInterstitial(adUnitID: self.adID)
                    let req = GADRequest()
                    self.interstitial.load(req)
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle(Text("Loans"))
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                        self.showingAdder.toggle()}){
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.medium)
                            Text("Loan")
                        }
                }.sheet(isPresented: self.$showingAdder, onDismiss: {
                    if self.interstitial.isReady {
                        let root = UIApplication.shared.windows.first?.rootViewController
                        self.interstitial.present(fromRootViewController: root!)
                    }
                    else {
                        print("Not Ready")
                    }}) {
                        LoanAdder().environment(\.managedObjectContext, self.managedObjectContext)
                    })
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = false
                }
            }
        .padding(.leading, ipadPadding)
    }
    
    func deleteLoans(at offsets: IndexSet) {
        for offset in offsets {
            // find this loan in our fetch request
            let loan = loans[offset]

            // delete it from the context
            managedObjectContext.delete(loan)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("Error While Deleting Loan")
        }
    }
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Test data
        return LoanView().environment(\.managedObjectContext, context)
    }
}
