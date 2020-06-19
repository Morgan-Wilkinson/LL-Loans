//
//  BarView.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/14/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BarView: View {
    public var title: String
    public var cornerImage: Image = Image(systemName: "chart.bar")
    public var valueSpecifier: String = "%.3f"
    public var currentMonthIndex: Int
    
    @ObservedObject var loan: Loans
    //@State var monthsSeries: [String]
   // @State var barValues: [[Double]]
    @State var pickerSelection = 0
    @State private var width: CGFloat = 0
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentMonth: String = ""
    @State private var currentValue: Double = 0 
    
    /*
    public init(title: String, cornerImage:Image? = Image(systemName: "chart.bar"), valueSpecifier: String? = "%.3f", currentMonthIndex: Int, loan: ObservedObject<Loans>){
        self.title = title
        self.cornerImage = cornerImage!
        self.valueSpecifier = valueSpecifier!
        self.currentMonthIndex = currentMonthIndex
        //self._monthsSeries = State(initialValue: monthsSeries)
        //self._barValues = State(initialValue: barValues)
        // monthsSeries: [String], barValues: [[Double]]
        self.loan = loan
    }
 */

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
                        .foregroundColor(Color.normalText)
                 }
                 // Shows Values
                 else{
                    Text("\(self.currentValue, specifier: self.valueSpecifier) - \(self.currentMonth)")
                        .font(.headline)
                        .foregroundColor(Color.normalText)
                 }
                 Spacer()
                 self.cornerImage
                     .imageScale(.large)
            }
            
            GeometryReader { geometry in
                BarRow(loan: self.loan, pickerSelection: self.pickerSelection, touchLocation: self.$touchLocation, currentMonthIndex: self.currentMonthIndex)
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
        let arraySize = self.loan.allThreeSmallArray[self.pickerSelection].count
        guard arraySize > 0 else { return 0}
     let index = max(0,min(arraySize-1,Int(floor((self.touchLocation*self.width)/(self.width/CGFloat(arraySize))))))
        return self.loan.allThreeSmallArray[self.pickerSelection][index]
    }
    
    // Returns the current month of the selected bar 
    func getCurrentMonth() -> String {
        let arraySize = self.loan.smallMonthsSeries.count
        guard arraySize > 0 else { return ""}
     let index = max(0,min(arraySize-1,Int(floor((self.touchLocation*self.width)/(self.width/CGFloat(arraySize))))))
        return self.loan.smallMonthsSeries[index]
    }
}
/*
struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(
        title: "Model 3 sales", cornerImage: Image(systemName: "chart.bar"),
        valueSpecifier: "%.2f", currentMonthIndex: 4, loan: <#Loans#>)
    }
}

// , monthsSeries: ["Jan", "Feb", "Mar", "Apr", "Jun"],
// barValues: [[75.0, 9635, 1523, 62.36, 159], [326.25, 159.3658, 15884, 526.84, 515], [854, 1520, 3698, 157.2, 158.3698]]
*/
