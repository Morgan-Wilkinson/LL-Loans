//
//  WhatIf.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/17/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct WhatIf: View {
    var body: some View {
        // For Split view on ipad work around.
        let ipadPadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0
        
        return NavigationView {
            List(){
                Section(header: SectionHeaderView(text: "Calculators", icon: "plusminus"), footer: Text("Here are some calculators that can quickly check different scenarios for you.")){
                    Group{
                        NavigationLink(destination: CompoundInterest()) {
                            HStack{
                                Image(systemName: "clock")
                                    .foregroundColor(Color.bigButtonText)
                                    .imageScale(.medium)
                                Text("Compound Interest")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.bigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: CreditCardPayoff()) {
                            HStack{
                                Image(systemName: "creditcard")
                                    .foregroundColor(Color.bigButtonText)
                                    .imageScale(.medium)
                                Text("Credit Card Payoff")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.bigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: DebtToIncomeRatioChecker()) {
                            HStack{
                                Image(systemName: "divide")
                                    .foregroundColor(Color.bigButtonText)
                                    .imageScale(.medium)
                                    .rotationEffect(.degrees(90))
                                Text("Debt-Income Ratio")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.bigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: MonthlyPayment()) {
                            HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.bigButtonText)
                                    .imageScale(.medium)
                                Text("Monthly Payment & Interest")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.bigButtonText)
                            }
                        }
                    }
                }.listRowBackground(Color.bigButton)
                .buttonStyle(PlainButtonStyle())
            }.navigationBarTitle(Text("What If Calculator"))
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding(.leading, ipadPadding)
    }
}

struct WhatIf_Previews: PreviewProvider {
    static var previews: some View {
        WhatIf()
    }
}
