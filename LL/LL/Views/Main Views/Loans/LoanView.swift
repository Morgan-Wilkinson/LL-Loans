//
//  LoanView.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import CoreData

struct LoanView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
    
    @State private var navigationSelectionTag: Int? = 0
    
    
    /*
    init() {
       // UITableView.appearance().backgroundColor = .clear
       // UITableViewCell.appearance().backgroundColor = .clear
       // UITableView.appearance().separatorStyle = .none
    }
    */
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM y"
        
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .long
        
        let headerText = self.loans.count != 0 ? "Loans" : ""
        let footerText = self.loans.count != 0 ? "Here are your loans as of \(formatter2.string(from: Date()))!" : "You're not tracking any loans, add some!"
       
        return NavigationView {
            List{
                Section(header: Text(headerText), footer: Text(footerText)) {
                    
                    if self.loans.count == 0 {
                        NoLoans()
                    }
                    else {
                        ForEach(self.loans, id: \.id) { loan in
                            NavigationLink(destination: LoanDetail(loanItem: loan)) {
                                SimpleRow(name: loan.name, loanType: loan.typeOfLoan, origin: loan.origin, currentDueDate: loan.currentDueDate, nextDueDate: formatter.string(from: loan.nextDueDate), dueAmount: Double(truncating: loan.currentPrincipal))
                            }.buttonStyle(PlainButtonStyle())
                            // This will change the background to show due items
                            //.listRowBackground(Calendar.current.dateComponents([.day], from: loan.currentDueDate, to: Date()).day! < 5 ?  Color("UpcomingPayment") : Color("SimpleRow"))
                        }.onDelete(perform: self.deleteLoans)
                    }
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Loans"))
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: LoanAdder()){
               HStack{
                   Image(systemName: "plus.circle.fill")
                       .foregroundColor(.blue)
                       .imageScale(.medium)
                   Text("Loan")
               }
            })
        }
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

struct NoLoans: View {
    
    var body: some View{
        NavigationLink(destination: LoanAdder()) {
            Text("New Loan")
                .fontWeight(.bold)
                .font(.title)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color("SimpleRow"))
                .padding(5)
        }.listRowBackground(Color.blue)
        .buttonStyle(PlainButtonStyle())
    }
}
struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Test data
        return LoanView().environment(\.managedObjectContext, context)
    }
}
