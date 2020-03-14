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
        
    @GestureState private var didPress: Bool = false
    @State var isDragging: Bool = false
    
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
                            BarView(value: CGFloat(data), width: Float(geometry.frame(in: .local).width - 22),
                                    numberOfPoints: self.barValues[self.pickerSelection].count, cornerRadius: 20)
                           // .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        }
                    }.padding().animation(.spring())
                    .gesture(DragGesture()
                        .onChanged({ value in
                            self.touchLocation = value.location.x
                        })
                        .onEnded({ value in
                            self.touchLocation = -1
                        }))
                    
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
