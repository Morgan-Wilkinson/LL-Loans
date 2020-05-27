//
//  BarView.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/14/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BarView: View {
    let textColor = Color("Text")
    public var title: String
    public var cornerImage: Image
    public var valueSpecifier: String
    public var currentMonthIndex: Int
    
    @State var monthsSeries: [String]
    @State var barValues: [[Double]]
    @State var pickerSelection = 0
    @State private var width: CGFloat = 0
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentMonth: String = ""
    @State private var currentValue: Double = 0 

    public init(title: String, cornerImage:Image? = Image(systemName: "chart.bar"), valueSpecifier: String? = "%.3f", currentMonthIndex: Int, monthsSeries: [String], barValues: [[Double]]){
        self.title = title
        self.cornerImage = cornerImage!
        self.valueSpecifier = valueSpecifier!
        self.currentMonthIndex = currentMonthIndex
        self._monthsSeries = State(initialValue: monthsSeries)
        self._barValues = State(initialValue: barValues)
    }

    public var body: some View {
        VStack(alignment: .leading){
            Picker(selection: self.$pickerSelection, label: Text("Stats")){
                // Balance Interest Principal
                Text("Balance").tag(0)
                Text("Interest").tag(1)
                Text("Principal").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            .padding([.top])

            HStack{
                 // Shows Title
                 if(!self.showValue){
                     Text(self.title)
                        .font(.headline)
                        .foregroundColor(self.textColor)
                 }
                 // Shows Values
                 else{
                    Text("\(self.currentValue, specifier: self.valueSpecifier) - \(self.currentMonth)")
                        .font(.headline)
                        .foregroundColor(self.textColor)
                 }
                 Spacer()
                 self.cornerImage
                     .imageScale(.large)
            }
            
            GeometryReader { geometry in
                BarRow(currentMonthIndex: self.currentMonthIndex, data: self.$barValues[self.pickerSelection], touchLocation: self.$touchLocation)
                  .gesture(DragGesture()
                    .onChanged({ value in
                        self.width = geometry.frame(in: CoordinateSpace.local).width
                        self.touchLocation = value.location.x / self.width
                        self.showValue = true
                        self.currentValue = self.getCurrentValue()
                        self.currentMonth = self.getCurrentMonth()
                        self.showLabelValue = true

                    })
                    .onEnded({ value in
                        self.showValue = false
                        self.showLabelValue = false
                        self.touchLocation = -1
                    }))
                    .gesture(TapGesture())
            }.id(self.pickerSelection)
        }.frame(minHeight: 250)
    }
    // Returns the current value of the selected bar
    func getCurrentValue() -> Double{
        guard self.barValues[self.pickerSelection].count > 0 else { return 0}
     let index = max(0,min(self.barValues[self.pickerSelection].count-1,Int(floor((self.touchLocation*self.width)/(self.width/CGFloat(self.barValues[self.pickerSelection].count))))))
        return self.barValues[self.pickerSelection][index]
    }
    
    // Returns the current month of the selected bar 
    func getCurrentMonth() -> String {
        guard self.monthsSeries.count > 0 else { return ""}
     let index = max(0,min(self.monthsSeries.count-1,Int(floor((self.touchLocation*self.width)/(self.width/CGFloat(self.monthsSeries.count))))))
        return self.monthsSeries[index]
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(
        title: "Model 3 sales", cornerImage: Image(systemName: "chart.bar"),
        valueSpecifier: "%.2f", currentMonthIndex: 4, monthsSeries: ["Jan", "Feb", "Mar", "Apr", "Jun"],
        barValues: [[75.0, 9635, 1523, 62.36, 159], [326.25, 159.3658, 15884, 526.84, 515], [854, 1520, 3698, 157.2, 158.3698]])
    }
}
