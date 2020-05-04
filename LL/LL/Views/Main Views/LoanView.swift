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

    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM y"
        
        return NavigationView {
            VStack {
                VStack{
                    List {
                        Section(header: Text("Loans").font(.headline), footer: Text("Here is an overview of all your loans.")){
                            ForEach(self.loans, id: \.id) { loan in
                                VStack{
                                    NavigationLink(destination: LoanDetail(loanItem: loan)) {
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text("\(loan.name) - ")
                                                Text("$\(loan.currentPrincipal)")
                                            }
                                            Text("Next Payment Date: \(formatter.string(from: loan.nextDueDate))").font(.caption)
                                        }
                                    }
                                }
                            }.onDelete(perform: deleteLoans)
                            
                        }
                        
                        Section(header: Text("Total").font(.headline), footer: Text("Here is the total amount owed as of \(Date()).")){
                            Text("Total Debt")
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("Overview")
                }.navigationBarItems(leading: EditButton(), trailing: NavigationLink(destination: LoanAdder()){ // Error on EditButton delete
                           HStack{
                                   Image(systemName: "plus.circle.fill")
                                       .foregroundColor(.blue)
                                       .imageScale(.medium)
                                   Text("Loan")
                           }
                       }
                   )
            }
        }
    }
    func deleteLoans(at offsets: IndexSet) {
        for offset in offsets {
            // find this loan in our fetch request
            let loan = loans[offset]

            // delete it from the context
            managedObjectContext.delete(loan)
        }

        // save the context
        try? managedObjectContext.save()
    }
}


struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Test data
        return LoanView().environment(\.managedObjectContext, context)
    }
}
