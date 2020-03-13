//
//  ChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var chartData: [[Double]]
    @State var normalizedChartData: [[Double]]
    var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var cornerImage: Image
    public var valueSpecifier:String
    
    @State public var changedData: Bool = false
    @State private var pickerSelection = 0
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
    var isFullWidth:Bool {
        return self.formSize == ChartForm.large
    }
    public init(chartData: [[Double]], normalizedChartData: [[Double]],data: ChartData, title: String, legend: String? = nil, style: ChartStyle = Styles.barChartStyleOrangeLight, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, cornerImage:Image? = Image(systemName: "waveform.path.ecg"), valueSpecifier: String? = "%.1f"){
        self.chartData = chartData
        self._normalizedChartData = State(initialValue: normalizedChartData)
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.barChartStyleOrangeDark
        self.formSize = form!
        self.dropShadow = dropShadow!
        self.cornerImage = cornerImage!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                .cornerRadius(20)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 8 : 0)
            VStack(alignment: .leading){
                // Header
                VStack{
                    HStack{
                        if(!showValue){
                            Text(self.title)
                                .font(.headline)
                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                        }else{
                            Text("\(self.currentValue, specifier: self.valueSpecifier)")
                                .font(.headline)
                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                        }
                        if(self.formSize == ChartForm.large && self.legend != nil && !showValue) {
                            Text(self.legend!)
                                .font(.callout)
                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.accentColor : self.style.accentColor)
                                .transition(.opacity)
                                .animation(.easeOut)
                        }
                        Spacer()
                        self.cornerImage
                            .imageScale(.large)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    }.padding([.top, .leading, .trailing])
                    
                    // Picker
                    Picker(selection: self.$pickerSelection, label: Text("Stats")) {
                        Text("Balances").tag(0)
                        Text("Interests").tag(1)
                        Text("Principals").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onReceive([self.pickerSelection].publisher.first()) { (value) in
                        print(value)
                    }
                }
                
                 // Graph
                VStack{
                    BarChartRow(data: (ChartData)(points: chartData[pickerSelection]).points.map{$0.1}, normalizedData: self.$normalizedChartData[pickerSelection],
                                accentColor: self.colorScheme == .dark ? self.darkModeStyle.accentColor : self.style.accentColor,
                                gradient: self.colorScheme == .dark ? self.darkModeStyle.gradientColor : self.style.gradientColor, touchLocation: self.$touchLocation)
                    if self.legend != nil  && self.formSize == ChartForm.medium && !self.showLabelValue{
                        Text(self.legend!)
                            .font(.headline)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                            .padding()
                    }else if ((ChartData)(points: chartData[pickerSelection]).valuesGiven && self.getCurrentValue() != nil) {
                        LabelView(arrowOffset: self.getArrowOffset(touchLocation: self.touchLocation),
                                  title: .constant(self.getCurrentValue()!.0))
                            .offset(x: self.getLabelViewOffset(touchLocation: self.touchLocation), y: -6)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    }
                }
                .padding(.horizontal)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.touchLocation = value.location.x/self.formSize.width
                        self.showValue = true
                        self.currentValue = self.getCurrentValue()?.1 ?? 0
                        if((ChartData)(points: self.chartData[self.pickerSelection]).valuesGiven && self.formSize == ChartForm.medium) {
                            self.showLabelValue = true
                    }})
                    .onEnded({ value in
                        self.showValue = false
                        self.showLabelValue = false
                        self.touchLocation = -1
                    }))
                    .gesture(TapGesture())
            }
        }
    }
    
    func getArrowOffset(touchLocation:CGFloat) -> Binding<CGFloat> {
        let realLoc = (self.touchLocation * self.formSize.width) - 50
        if realLoc < 10 {
            return .constant(realLoc - 10)
        }else if realLoc > self.formSize.width-110 {
            return .constant((self.formSize.width-110 - realLoc) * -1)
        } else {
            return .constant(0)
        }
    }
    
    func getLabelViewOffset(touchLocation:CGFloat) -> CGFloat {
        return min(self.formSize.width-110,max(10,(self.touchLocation * self.formSize.width) - 50))
    }
    
    func getCurrentValue() -> (String,Double)? {
        guard (ChartData)(points: chartData[self.pickerSelection]).points.count > 0 else { return nil}
        let index = max(0,min((ChartData)(points: chartData[self.pickerSelection]).points.count-1,Int(floor((self.touchLocation*self.formSize.width)/(self.formSize.width/CGFloat((ChartData)(points: chartData[self.pickerSelection]).points.count))))))
        return (ChartData)(points: chartData[self.pickerSelection]).points[index]
    }
}

#if DEBUG
struct ChartView_Previews : PreviewProvider {
    static var previews: some View {
        BarChartView(chartData: [[9.5,96.3, 100.0], [63.5, 1, 145.3], [102, 500, 9.6]], normalizedChartData: [[0.03, 0.7, 0.25], [0.15, 1.0, 0.9], [0.52, 0.63, 0.1]], data: TestData.values ,
                     title: "Model 3 sales",
                     legend: "Quarterly",
                     valueSpecifier: "%.0f")
    }
}
#endif
