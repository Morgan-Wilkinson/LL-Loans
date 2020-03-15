//
//  BarView.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/14/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BarView: View {
     @State var barValues : [[Double]]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(barValues:
        [
            [0.5,0.150,0.50,0.100,0.200,0.110,0.30,0.170,0.50],
        [0.200,0.110,0.30,0.170,0.50, 0.100,0.100,0.100,0.200],
        [0.10,0.20,0.50,0.100,0.120,0.90,0.180,0.200,0.40]
        ])
    }
}
