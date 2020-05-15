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
    var principal: Double
    var interest: Double
    var balance: Double
    var valueSpecifier: String = "%.2f"
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Group {
                    Text("\(self.month)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width / 6)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\((self.principal + self.interest), specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width / 6)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.principal, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width / 6)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.interest, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width / 6)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.balance, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width / 6)
                    Spacer()
                }
            }.padding()
        }
    }
}

struct BreakdownRow_Previews: PreviewProvider {
    static var previews: some View {
        BreakdownRow(month: "Jan 20", principal: 1500.00, interest: 1500.00, balance: 10000)
    }
}
