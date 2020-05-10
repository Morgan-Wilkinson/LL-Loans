//
//  BreakdownRow.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BreakdownRow: View {
    var month: String
    var payment: Double
    var principal: Double
    var interest: Double
    var balance: Double
    var valueSpecifier: String = "%.2f"
    
    var body: some View {
        HStack{
            Group {
                Text("\(month)")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Divider()
                Spacer()
            }
            
            Group{
                Text("\((principal + interest), specifier: valueSpecifier)")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Divider()
                Spacer()
            }
            
            Group{
                Text("\(principal, specifier: valueSpecifier)")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            
                Divider()
                Spacer()
            }
            
            Group{
                Text("\(interest, specifier: valueSpecifier)")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Divider()
                Spacer()
            }
            
            Group{
                Text("\(balance, specifier: valueSpecifier)")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }.padding()
    }
}

struct BreakdownRow_Previews: PreviewProvider {
    static var previews: some View {
        BreakdownRow(month: "Jan 20", payment: 3000.00, principal: 1500.00, interest: 1500.00, balance: 10000)
    }
}
