//
//  PaymentBreakdownDetail.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/9/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct PaymentBreakdownDetail: View {
    var valueSpecifier: String = "%.2f"
    public var title: String
    @State var monthsSeries: [String]
    @State var barValues: [[Double]]

    public var body: some View {
        
             //ZStack{
                 //VStack(alignment: .leading){
                    //ScrollView{
                    HStack {
                        
                        List(){
                            Section(header: Text("Date")) {
                                ForEach(monthsSeries,  id: \.self){ month in
                                    Text("\(month)")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        
                                }
                            }
                        }.navigationBarTitle(self.title)
                        .listStyle(GroupedListStyle())
                        .disabled(true)
                        
                        
                        BreakdownList(title: "Principal", barValues: barValues[2])
                        BreakdownList(title: "Interest", barValues: barValues[1])
                        BreakdownList(title: "Balance", barValues: barValues[0])
                    }
                    //Rectangle().fill(Color.gray).opacity(0.4).frame(width: CGFloat(1))
                //}
                
            //}.padding(.horizontal)
            
        //}
    }
}

struct PaymentBreakdownDetail_Previews: PreviewProvider {
    static var previews: some View {
        PaymentBreakdownDetail(title: "Payment Breakdown Detail", monthsSeries: ["Jan", "Feb", "Mar", "Apr", "Jun"],
        barValues: [[75.0, 9635, 1523, 62.36, 159], [326.25, 159.3658, 15884, 526.84, 515], [854, 1520, 3698, 157.2, 158.3698]])
    }
}


/*
 ForEach(0..<self.monthsSeries.count, id: \.self) { i in
     BreakdownList(month: self.monthsSeries[i], payment: self.barValues[0][i], principal: self.barValues[1][i], interest: self.barValues[2][i])
     
 }
 */
