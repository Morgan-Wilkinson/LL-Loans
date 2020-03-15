//
//  BarView.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/14/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BarView: View {
    private var data: ChartData
    public var title: String
    public var cornerImage: Image
    public var valueSpecifier:String

    @State var barValues: [[Double]]
    @State var pickerSelection = 0
    @State private var width: CGFloat = 0
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }

    public init(data:ChartData, title: String, cornerImage:Image? = Image(systemName: "chart.bar"), valueSpecifier: String? = "%.1f", barValues: [[Double]]){
        self.data = data
        self.title = title
        self.cornerImage = cornerImage!
        self.valueSpecifier = valueSpecifier!
        self._barValues = State(initialValue: barValues)
    }

    public var body: some View {
     GeometryReader { geometry in
         ZStack{
             Rectangle()
                 .fill(Color.white)
                 .cornerRadius(20)
                 .shadow(radius: 8)
             VStack(alignment: .leading){
                    Picker(selection: self.$pickerSelection, label: Text("Stats"))
                        {
                        Text("Balance").tag(0)
                        Text("Interest").tag(1)
                        Text("Principal").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding([.top, .leading, .trailing])
                VStack{
                 HStack{
                     // Shows Title
                     if(!self.showValue){
                         Text(self.title)
                             .font(.headline)
                     }
                     // Shows Values
                     else{
                         Text("\(self.currentValue, specifier: self.valueSpecifier)")
                             .font(.headline)
                     }
                     Spacer()
                     // Corner Image - Dont really need
                     self.cornerImage
                         .imageScale(.large)
                 }.padding([.leading, .bottom, .trailing])
                 //ForEach(self.barValues[self.pickerSelection], id: \.self){ i in
                    BarRow(data: self.$barValues[self.pickerSelection], touchLocation: self.$touchLocation)
                }
             }
            }.padding()
             .gesture(DragGesture()
                 .onChanged({ value in
                     self.width = geometry.frame(in: CoordinateSpace.local).width
                     self.touchLocation = value.location.x / self.width
                     self.showValue = true
                     self.currentValue = self.getCurrentValue()?.1 ?? 0
                     self.showLabelValue = true

                 })
                 .onEnded({ value in
                     self.showValue = false
                     self.showLabelValue = false
                     self.touchLocation = -1
                 }))
             .gesture(TapGesture())
        }
    }
    func getCurrentValue() -> (String,Double)? {
     guard self.data.points.count > 0 else { return nil}
     let index = max(0,min(self.data.points.count-1,Int(floor((self.touchLocation*self.width)/(self.width/CGFloat(self.data.points.count))))))
     return self.data.points[index]
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(data: ChartData(points: [75.0, 9635, 1523, 62.36, 159, 326.25, 159.3658, 15884]),
        title: "Model 3 sales",
        valueSpecifier: "%.2f",
        barValues: [[75.0, 9635, 1523, 62.36, 159], [326.25, 159.3658, 15884, 526.84, 515], [854, 1520, 3698, 157.2, 158.3698]])
    }
}
