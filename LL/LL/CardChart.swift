//
//  CardChart.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct CardChart: View {
    var chartData: ([Double], [Double], [Double])
        @State var pickerSelection = 0
        @State var barValues : [[CGFloat]] =
            [
            [5,150,50,100,200,110,30,170,50],
            [200,110,30,170,50, 100,100,100,200],
            [10,20,50,100,120,90,180,200,40]
            ]
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 10)
                .padding()
            
            VStack(alignment: .center){
                Text("History & Projections").foregroundColor(.black)
                    .font(.title)

                Picker(selection: $pickerSelection, label: Text("Stats"))
                    {
                    Text("Balances").tag(0)
                    Text("Principals").tag(1)
                    Text("Interests").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                HStack(alignment: .center, spacing: 10)
                {
                    ForEach((chartData.0), id: \.self){
                        data in
                        
                        BarView(value: (CGFloat)(data), length: (CGFloat)(self.chartData.0.count), cornerRadius: 0)
                    }
                }.padding(.horizontal)
                .animation(.default)
               
            }.padding()
            
        }
    }
}

struct CardChart_Previews: PreviewProvider {
    static var previews: some View {
        CardChart(chartData: (chartData: [95.3, 96.3], [85.5, 159.0], [1500.0, 1600.0]))
    }
}

/*
 RoundedRectangle(cornerRadius: 25, style: .continuous)
 .fill(Color.white)
 */
