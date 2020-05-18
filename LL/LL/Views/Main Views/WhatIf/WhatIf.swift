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
        NavigationView {
            List(){
                Section(header: CalculatorHeader(), footer: Text("Here are some calculators that can quickly check different scenarios for you!")){
                    Group{
                        NavigationLink(destination: MonthlyPayment()) {
                            HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                                Text("Monthly Payment")
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color("Text"))
                            }
                        }
                        
                        NavigationLink(destination: RefinanceChecker()) {
                            HStack{
                                Image(systemName: "arrow.2.circlepath")
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                                Text("Refinance Checker")
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color("Text"))
                            }
                        }
                    }
                }.listRowBackground(Color("UpcomingPayment"))
                .buttonStyle(PlainButtonStyle())
            }.navigationBarTitle(Text("What If Calculator"))
            .listStyle(GroupedListStyle())
            
        }
    }
}

struct CalculatorHeader: View {
    var body: some View{
        HStack{
            Image(systemName: "plusminus")
            Text("Calculators")
        }
    }
}

struct WhatIf_Previews: PreviewProvider {
    static var previews: some View {
        WhatIf()
    }
}
