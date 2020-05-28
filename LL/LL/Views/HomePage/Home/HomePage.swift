//
//  HomePage.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/15/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct HomePage: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var selection = 0
    @State var showSplash = true
    // Get the managed object context from the shared persistent container.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var body: some View {
        ZStack{
            TabView(selection: $selection) {
                LoanView().environment(\.managedObjectContext, context)
                    .tabItem {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("Loans")
                    }
                    .tag(0)
                
                /*
                Refinance()
                    .tabItem {
                        Image(systemName: "arrow.2.circlepath")
                        Text("Refinance")
                    }
                    .tag(1)
                */
                WhatIf()
                .tabItem {
                   Image(systemName: "questionmark.circle")
                   Text("What If?")
                 }
                 .tag(2)
            }
            
            SplashScreen()
              .opacity(showSplash ? 1 : 0)
              .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                  SplashScreen.shouldAnimate = false
                  withAnimation() {
                    self.showSplash = false
                  }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()//.environment(\.colorScheme, .dark)
    }
}
