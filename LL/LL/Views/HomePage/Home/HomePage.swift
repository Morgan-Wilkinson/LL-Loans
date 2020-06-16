//
//  HomePage.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/15/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import StoreKit

struct HomePage: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var selection = 0
    @State var showSplash = true
    // Get the managed object context from the shared persistent container.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var body: some View {
        ZStack{
            TabView(selection: $selection) {
                Dashboard().environment(\.managedObjectContext, context)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Dashboard")
                    }
                    .tag(0)
                
                LoanView().environment(\.managedObjectContext, context)
                    .tabItem {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("Loans")
                    }
                    .tag(1)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut) {
                    self.showSplash = false
                  }
                }
            }
        }.onAppear{
            // Prompt for App Store Review
            // If the count has not yet been stored, this will return 0
            var count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
            count += 1
            UserDefaults.standard.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)

            print("Process completed \(count) time(s)")

            // Get the current bundle version for the app
            let infoDictionaryKey = kCFBundleVersionKey as String
            guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
                else { fatalError("Expected to find a bundle version in the info dictionary") }

            let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)

            // Has the process been completed several times and the user has not already been prompted for this version?
            if count >= 4 && currentVersion != lastVersionPromptedForReview {
                let twoSecondsFromNow = DispatchTime.now() + 2.0
                DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                        SKStoreReviewController.requestReview()
                        UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage().environment(\.colorScheme, .dark)
    }
}
