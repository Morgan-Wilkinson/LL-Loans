//
//  HomePage.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/15/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct HomePage: View {
    @State private var selection = 0
    @Environment(\.managedObjectContext) var managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var body: some View {
        TabView(selection: $selection) {
            LoanView().environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "phone.fill")
                    Text("Loans")
                }
                .tag(0)
            Settings()
               .tabItem {
                  Image(systemName: "tv.fill")
                  Text("Settings")
                }
                .tag(1)
            Settings()
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Settings")
                }
                .tag(2)
        }//.edgesIgnoringSafeArea(.top)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
