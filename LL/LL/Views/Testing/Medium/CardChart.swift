//
//  CardChart.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct CardChart: View {
    @State var pickerSelection = 0
    @State private var touchLocation: CGFloat = -1.0
    @State var barValues : [[Double]]
        
    @State var scaleValue: Double = 1
    @State var scaleUp: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .padding()
                VStack{
                    Text("Bar Charts").foregroundColor(.black)
                        .font(.title)
                        .padding(.top)

                    Picker(selection: self.$pickerSelection, label: Text("Stats"))
                        {
                        Text("Balance").tag(0)
                        Text("Interest").tag(1)
                        Text("Principal").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                    HStack(alignment: .center, spacing: 10)
                    {
                        ForEach(self.barValues[self.pickerSelection], id: \.self){ data in
                            GeometryReader { geo in
                                BarCell(value: data,
                                        index: self.barValues[self.pickerSelection].firstIndex(of: data)!,
                                        width: Float(geometry.frame(in: .local).width - 22),
                                        numberOfDataPoints: self.barValues[self.pickerSelection].count,
                                        touchLocation: self.$touchLocation)
                
                                    //.scaleEffect(self.touchLocation > CGFloat(geo.frame(in: .local).minX) && self.touchLocation < CGFloat(geo.frame(in: .local).maxX) ? 1.4 : 1, anchor: .bottom)
                                    
                                    /*
                                .gesture(DragGesture(coordinateSpace: .local)
                                .onChanged({ value in
                                    self.scaleUp = true
                                    self.scaleValue = 1.4
                                    self.touchLocation = value.location.x / geo.frame(in: .local).width
                                    })
                                .onEnded({ _ in
                                    self.scaleUp = false
                                    self.scaleValue = data
                                    self.touchLocation = -1
                                }))
 */

                            }
                        }
                    }.padding().animation(.spring())
                                        
                }.padding()
            }
        }
    }


    init(barValues: [[Double]]) {
         self._barValues = State(initialValue: barValues)
    }
}

struct CardChart_Previews: PreviewProvider {
    static var previews: some View {
        CardChart(barValues:
            [
                [0.5,0.150,0.50,0.100,0.200,0.110,0.30,0.170,0.50],
            [0.200,0.110,0.30,0.170,0.50, 0.100,0.100,0.100,0.200],
            [0.10,0.20,0.50,0.100,0.120,0.90,0.180,0.200,0.40]
            ])
    }
}

/*
 RoundedRectangle(cornerRadius: 25, style: .continuous)
 .fill(Color.white)
 */
