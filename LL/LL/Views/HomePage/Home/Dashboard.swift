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
        var totalPrincipal: Double = 0
        
        if self.loans.count > 0 {
            for i in self.loans {
                totalPrincipal += Double(truncating: i.originalPrincipal)
            }
        }
        
        return NavigationView{
            List {
                Section(header: SectionHeaderView(text: "Number of Loans", icon: "number.square")) {
                    Text("You have \(self.loans.count) loans to be paid off.")
                }
                if self.loans.count > 0 {
                    Section(header: SectionHeaderView(text: "Total Principal", icon: "dollarsign.square")) {
                        Text("Your total principal for your loans is $\(totalPrincipal, specifier: "%.2f").")
                            .lineLimit(nil)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                    
                    Section(header: SectionHeaderView(text: "Next Payment", icon: "calendar")) {
                        Text("Next loan to be paid is")
                            .lineLimit(nil)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(Text(dateFormatter.string(from: Date())))
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
