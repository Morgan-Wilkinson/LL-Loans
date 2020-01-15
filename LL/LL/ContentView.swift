//
//  ContentView.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
        
        /*
        return NavigationView{
                Section(header: Text("Loans")) {
                    VStack{
                        ForEach(self.loans, id: \.self) { loan in
                            NavigationLink(destination: LoanView(loan: loan)) {
                                VStack(alignment: .leading) {
                                    Text(loan.name ?? "Hi")
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Overview"))
                //.navigationBarItems(leading: Button())
                .navigationBarItems(trailing: EditButton())
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
