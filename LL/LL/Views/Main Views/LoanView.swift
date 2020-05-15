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
    
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM y"
        
        return NavigationView {
            VStack {
                VStack{
                    List {
                        //Section(header: Text("Loans").font(.headline), footer: Text("Here is an overview of all your loans.")){
                            ForEach(self.loans, id: \.id) { loan in
                                //VStack{
                                    NavigationLink(destination: LoanDetail(loanItem: loan)) {
                                        VStack(alignment: .leading){
                                            SimpleRow(name: loan.name, origin: loan.origin, nextDueDate: formatter.string(from: loan.nextDueDate), dueAmount: Double(truncating: loan.currentPrincipal))
                                        }
                                    }
                                //}
                            }.onDelete(perform: deleteLoans)
                        //}//.foregroundColor(Color.red)
                    }
                    //.listStyle(GroupedListStyle())
                    .listRowInsets(EdgeInsets())
                    .navigationBarTitle("Loans")
                }.navigationBarItems(leading: EditButton(), trailing:
                    NavigationLink(destination: LoanAdder()){
                           HStack{
                                   Image(systemName: "plus.circle.fill")
                                       .foregroundColor(.blue)
                                       .imageScale(.medium)
                                   Text("Loan")
                           }
                       }
                   )
            }.background(Color("Dashboard"))
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
