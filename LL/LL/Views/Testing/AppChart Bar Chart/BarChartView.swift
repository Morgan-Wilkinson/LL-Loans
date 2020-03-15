//
//  ChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    private var data: ChartData
    public var title: String
    public var cornerImage: Image
    public var valueSpecifier:String
    
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
    
    public init(data:ChartData, title: String, cornerImage:Image? = Image(systemName: "chart.bar"), valueSpecifier: String? = "%.1f"){
        self.data = data
        self.title = title
        self.cornerImage = cornerImage!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 8)
                VStack(alignment: .leading){
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
                    }.padding()
                    
                   // BarRow(data: self.data.points.map{$0.1}, touchLocation: self.$touchLocation)
                }
            }
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
                    })
            )
                .gesture(TapGesture()
            )
        }
    }
    func getCurrentValue() -> (String,Double)? {
        guard self.data.points.count > 0 else { return nil}
        let index = max(0,min(self.data.points.count-1,Int(floor((self.touchLocation*self.width)/(self.width/CGFloat(self.data.points.count))))))
        return self.data.points[index]
    }
 
}

#if DEBUG
struct BarChartView_Previews : PreviewProvider {
    static var previews: some View {
        BarChartView(data: TestData.values ,
                     title: "Model 3 sales",
                     valueSpecifier: "%.2f")
    }
}
#endif
