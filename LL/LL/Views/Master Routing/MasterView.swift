//
//  MasterView.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/26/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    
    @State var show = false
    private let initialLaunchKey = "isInitialLaunch"
    
    var body: some View {
        VStack {
            if show || UserDefaults.standard.bool(forKey: initialLaunchKey){
                HomePage().transition(.move(edge: .bottom))
            } else {
                PageViewContainer( viewControllers: OnboardingPage.getAll.map({  UIHostingController(rootView: Introduction(page: $0) ) }), presentSignupView: {
                    withAnimation {
                        self.show = true
                    }
                    UserDefaults.standard.set(true, forKey: self.initialLaunchKey)
                }).transition(.scale)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
        }//.frame(maxHeight: .infinity)
            .background(Color.llBackground)
            
    }
}

    struct MasterView_Previews: PreviewProvider {
        static var previews: some View {
            MasterView().environment(\.colorScheme, .dark)
        }
    }
