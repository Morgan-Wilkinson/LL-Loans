//
//  BreakdownRow.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/9/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BreakdownList: View {
    //var title: String
    var barValues: [Double]
    var valueSpecifier: String = "%.2f"
    
    var body: some View {
        //List(){
            //Section(header: Text(title)) {
                ForEach(barValues,  id: \.self){ value in
                    Text("\(value, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                
                //}
           // }
        }
       // .listStyle(GroupedListStyle())
        //.disabled(true)
        
    }
}

struct BreakdownList_Previews: PreviewProvider {
    static var previews: some View {
        BreakdownList(barValues: [854, 1520, 3698, 157.2, 158.3698])
    }
}