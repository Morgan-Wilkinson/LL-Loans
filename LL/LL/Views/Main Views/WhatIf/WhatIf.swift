//
//  WhatIf.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/17/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct WhatIf: View {
    let BigButtonText = Color("BigButtonText")
    let bigButtonColor = Color("BigButtonColor")
    let cardColor = Color("Cards")
    var body: some View {
        NavigationView {
            List(){
                Section(header: SectionHeaderView(text: "Calculators", icon: "plusminus"), footer: Text("Here are some calculators that can quickly check different scenarios for you.")){
                    Group{
                        NavigationLink(destination: CompoundInterest()) {
                            HStack{
                                Image(systemName: "clock")
                                    .foregroundColor(BigButtonText)
                                    .imageScale(.medium)
                                Text("Compound Interest")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(BigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: CreditCardPayoff()) {
                            HStack{
                                Image(systemName: "creditcard")
                                    .foregroundColor(BigButtonText)
                                    .imageScale(.medium)
                                Text("Credit Card Payoff")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(BigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: DebtToIncomeRatioChecker()) {
                            HStack{
                                Image(systemName: "divide")
                                    .foregroundColor(BigButtonText)
                                    .imageScale(.medium)
                                    .rotationEffect(.degrees(90))
                                Text("Debt-Income Ratio")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(BigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: MonthlyPayment()) {
                            HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(BigButtonText)
                                    .imageScale(.medium)
                                Text("Monthly Payment & Interest")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(BigButtonText)
                            }
                        }
                        
                        NavigationLink(destination: RefinanceCalculator()) {
                            HStack{
                                Image(systemName: "arrow.2.circlepath")
                                    .foregroundColor(BigButtonText)
                                    .imageScale(.medium)
                                Text("Refinance Calculator")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(BigButtonText)
                            }
                        }
                    }
                }.listRowBackground(bigButtonColor)
                .buttonStyle(PlainButtonStyle())
            }.navigationBarTitle(Text("What If Calculator"))
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
        }
    }
}

struct WhatIf_Previews: PreviewProvider {
    static var previews: some View {
        WhatIf()
    }
}
