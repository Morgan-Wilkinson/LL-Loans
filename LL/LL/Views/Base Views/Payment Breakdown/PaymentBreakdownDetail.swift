//
//  PaymentBreakdownDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/9/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct PaymentBreakdownDetail: View {
    let cardColor = Color("Cards")
    let valueSpecifier: String = "%.2f"
    public var title: String
    public var monthlyPayment: Double
    @State var monthsSeries: [String]
    @State var barValues: [[Double]]
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    Rectangle().fill(self.cardColor)
                        .frame(width: geometry.size.width, height: geometry.size.height / 15)
                    HStack(){
                        Group {
                            Text("Date")
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(width: geometry.size.width / 6)
                            
                            Divider()
                            Spacer()
                        }
                        
                        Group{
                            Text("Payment")
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(width: geometry.size.width / 6)
                            
                            Divider()
                            Spacer()
                        }
                        
                        Group{
                            Text("Principal")
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(width: geometry.size.width / 6)
                        
                            Divider()
                            Spacer()
                        }
                        
                        Group{
                            Text("Interest")
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(width: geometry.size.width / 6)
                            
                            Divider()
                            Spacer()
                        }
                        
                        Group{
                            Text("Balance")
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(width: geometry.size.width / 6)
                            Spacer()
                        }
                    }.padding()
                }.frame(width: geometry.size.width, height: geometry.size.height / 15)
            
                List(){
                    ForEach(0..<self.barValues[0].count, id: \.self) { i in
                        BreakdownRow(month: self.monthsSeries[i], principal: self.barValues[2][i], interest: self.barValues[1][i], balance: self.barValues[0][i], monthlyPayment: self.monthlyPayment)
                    }.listRowInsets(EdgeInsets())
                    .listStyle(PlainListStyle())
                }
            }
        }.navigationBarTitle(self.title)
    }
}

struct PaymentBreakdownDetail_Previews: PreviewProvider {
    static var previews: some View {
        PaymentBreakdownDetail(title: "Payment Breakdown Detail", monthlyPayment: 20.00, monthsSeries: ["Jan", "Feb", "Mar", "Apr", "Jun"],
        barValues: [[75.0, 9635, 1523, 62.36, 159], [326.25, 159.3658, 15884, 526.84, 515], [854, 1520, 3698, 157.2, 158.3698]])
    }
}


/*
List(){
   ForEach(0..<barValues[0].count, id: \.self) { i in
       BreakdownRow(month: self.monthsSeries[i], payment: self.barValues[0][i], principal: self.barValues[1][i], interest: self.barValues[2][i], balance: self.barValues[0][i])
   }
}.navigationBarTitle(self.title)
*/
