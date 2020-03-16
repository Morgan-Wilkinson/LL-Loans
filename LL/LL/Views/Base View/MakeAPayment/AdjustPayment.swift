//
//  AdjustPayment.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/15/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct AdjustPayment: View {
     @State private var payment = ""
    
     let formatter = NumberFormatter()
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 8)
            
            VStack{
                Text("Enter What You Paid This Month")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("Paid More or Less This Month?")
                    .font(.title)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                Divider()
                TextField("What did you pay this month? E.g 150.95", text: self.$payment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                // Button
            }
        }.padding()
    }
}

struct AdjustPayment_Previews: PreviewProvider {
    static var previews: some View {
        AdjustPayment()
    }
}
