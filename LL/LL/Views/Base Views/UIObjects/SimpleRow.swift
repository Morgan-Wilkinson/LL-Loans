//
//  SimpleRow.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct SimpleRow: View {
    var name: String
    var origin: String
    var nextDueDate: String
    var dueAmount: Double
    let valueSpecifier: String = "%.2f"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("MintGreen"))
            VStack {
                VStack(alignment: .leading) {
                    HStack{
                        Spacer()
                        Text(origin)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }.padding(.bottom, 5.0)
                    Group{
                        HStack{
                            Text(name)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .font(.system(size: 25))
                            
                            Spacer()
                            
                            Text("\(dueAmount, specifier: valueSpecifier)")
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(5)
                                .background(Color.gray)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                        }
                    }
                    Divider()
                    Group{
                        HStack{
                            Text("Pay Day")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            
                            Spacer()
                            
                            Text(nextDueDate)
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(5)
                                .background(Color.gray)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                        }
                    }
                }
            }.padding()
        }
        //.padding()
        .shadow(radius: 5)
    }
}

struct SimpleRow_Previews: PreviewProvider {
    static var previews: some View {
        List{
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", origin: "West Bank", nextDueDate: "May 20", dueAmount: 1000.00)
        }
    }
}


/*
 GeometryReader { geometry in
     ZStack {
         RoundedRectangle(cornerRadius: 5, style: .continuous)
             .fill(Color.white)
         VStack() {
             VStack(alignment: .leading) {
                 Text("\(self.subtitle ?? "")")
                     .font(.headline)
                     .foregroundColor(.accentColor)
                     
                 
                 Text("\(self.bodyText)")
                     .font(.headline)
                     .foregroundColor(.accentColor)
                 
                 Text("\(self.footer ?? "")")
                     .font(.subheadline)
                     .fontWeight(.medium)
                     .foregroundColor(.black)
             }//.frame(width: geometry.size.width ,height: geometry.size.height)
                 .frame(minWidth: 0, maxWidth: .infinity)
             //.padding()
             Spacer()
         }
     }
     .frame(height: geometry.size.height / 5)
     .padding()
     .shadow(radius: 10)
     
 }
 */
