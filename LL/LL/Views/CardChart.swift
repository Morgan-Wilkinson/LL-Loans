//
//  CardChart.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct CardChart: View {
    var chartData: [[Double]]
    @State var pickerSelection = 0
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    var maxValue: [Double]
    init(chartData: [[Double]]) {
        self.chartData = chartData
         maxValue =
           [
               self.chartData[0].max() ?? 0,
               self.chartData[1].max() ?? 0,
               self.chartData[2].max() ?? 0
           ]
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .padding()
                
                VStack(alignment: .center){
                    Text("History & Projections").foregroundColor(.black)
                        .font(.title)

                    Picker(selection: self.$pickerSelection, label: Text("Stats")) {
                        Text("Balances").tag(0)
                        Text("Principals").tag(1)
                        Text("Interests").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                    //HStack(alignment: .center, spacing: 10)
                    HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.chartData[self.pickerSelection].count * 3))
                    {
                        ForEach(0..<self.chartData[self.pickerSelection].count, id: \.self){ i in
                            BarView(value: self.normalizedValue(index: i),  cornerRadius: 0, width: Float(geometry.frame(in: .local).width - 22), numberOfDataPoints: self.chartData[self.pickerSelection].count, index: i, touchLocation: self.$touchLocation)
                        }
                    }.padding(.horizontal)
                    .animation(.spring())
                   
                }.padding()
            }
            .gesture(DragGesture()
                    .onChanged({ value in
                        self.touchLocation = value.location.x / geometry.size.width
                        self.showValue = true
                        //self.currentValue = self.getCurrentValue()?.1 ?? 0
                        //if(self.data.valuesGiven && self.formSize == ChartForm.medium) {
                          //  self.showLabelValue = true
                        //}
                    })
                    .onEnded({ value in
                        self.showValue = false
                        self.showLabelValue = false
                        self.touchLocation = -1
                    })
            )
            
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        print("\(self.pickerSelection)\n")
        return Double(self.chartData[self.pickerSelection][index]) / maxValue[self.pickerSelection]
    }
}

struct CardChart_Previews: PreviewProvider {
    static var previews: some View {
        CardChart(chartData: [[95.3, 96.3], [10, 0], [1500.0, 1600.0]])
    }
}

/*
 RoundedRectangle(cornerRadius: 25, style: .continuous)
 .fill(Color.white)
 */
