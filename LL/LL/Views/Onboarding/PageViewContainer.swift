//
//  PageControl.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/26/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct PageViewContainer<Page: View>  : View {
    
    var viewControllers: [UIHostingController<Page>]
    @State var currentPage = 0
    var presentSignupView: (()->()) = {}
    
        
    var body: some View {
       return VStack {
            PageViewController(controllers: viewControllers, currentPage: self.$currentPage)
            
            PageIndicator(currentIndex: self.currentPage)
            
           VStack {
               Button(action: {
                   if self.currentPage < self.viewControllers.count - 1{
                       self.currentPage += 1
                   } else {
                       self.presentSignupView()
                   }
               }) {
                   HStack {
                       Text(currentPage == viewControllers.count - 1 ? "Get started" : "Next" )
                           .bold()
                           .frame(minWidth: 0, maxWidth: .infinity)
                           .padding()
                           .accentColor(Color.white)
                           .background(Color("HotPink"))
                           .cornerRadius(30)
                   }.padding()
               }
           }.padding(.vertical)
        }.background(Color.llBackground)
    }
}

struct PageViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        PageViewContainer( viewControllers: OnboardingPage.getAll.map({  UIHostingController(rootView: Introduction(page: $0) )  })).environment(\.colorScheme, .dark)
    }
}
