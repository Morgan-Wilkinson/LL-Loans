//
//  PaymentBreakdownDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/9/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
//import GoogleMobileAds

struct PaymentBreakdownDetail: View {
    
    let valueSpecifier: String = "%.2f"
    public var title: String
    public var monthlyPayment: Double
    @State var monthsSeries: [String]
    @State var barValues: [[Double]]
    @State var maxWidth: CGFloat = 0
    
    //@State var interstitial: GADInterstitial!
    //let adID: String = "ca-app-pub-2030770006889815/7603128128"
    
    //let ipadDevice = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    public var body: some View {
        return List(){
            GeometryReader { geometry in
                HStack(){
                    Group {
                        Text("Date")
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }.onAppear(perform: {self.maxWidth = geometry.size.width / 6})
                    
                    Group{
                        Text("Principal")
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }
                    
                    Group{
                        Text("Interest")
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }
                    
                    Group{
                        Text("Balance")
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }
                    
                    Group{
                        Text("Interest Totals")
                            .fontWeight(.regular)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Spacer()
                    }
                }
            }
            ForEach(0..<self.barValues[0].count, id: \.self) { i in
                BreakdownRow(month: self.monthsSeries[i], principal: self.barValues[2][i], interest: self.barValues[1][i], balance: self.barValues[0][i], interestAtPoint: self.barValues[3][i], maxWidth: self.$maxWidth)
                    .listRowBackground(i % 2 == 0 ?  Color.amortizationRow1 : Color.amortizationRow2)
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(self.title)
        
    }
}

struct PaymentBreakdownDetail_Previews: PreviewProvider {
    static var previews: some View {
        PaymentBreakdownDetail(title: "Payment Breakdown Detail", monthlyPayment: 20.00, monthsSeries: ["Jan", "Feb", "Mar", "Apr", "Jun"],
        barValues: [[75.0, 9635, 1523, 62.36, 159], [326.25, 159.3658, 15884, 526.84, 515], [854, 1520, 3698, 157.2, 158.3698]])
    }
}

