//
//  BookmarkSymbol.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/27/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BookmarkSymbol: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.03
                let middle = width / 2
                let topWidth = 0.25 * width
                let bottomHeight = 1.25 * height
                
                /*
                path.addLines([
                    // Left Top
                    CGPoint(x: (middle / 3) * 3, y: spacing),
                    
                    // Left Middle Edge
                    CGPoint(x: middle / 2, y: spacing + 100),
                    // Left bottom edge
                    CGPoint(x: middle - topWidth, y: bottomHeight),
                    // Middle arrow
                    CGPoint(x: middle, y: bottomHeight / 1.5 + spacing),
                    // right bottom edge
                    CGPoint(x: middle + topWidth, y: bottomHeight),
                    // Right Top
                    CGPoint(x: middle * 1.5, y: spacing)
                ])
                */
                
                path.move(to: CGPoint(x: middle / 2, y: spacing + 100))
                // Left Top
                path.addLine(to: CGPoint(x: (middle / 3) * 3, y: spacing))
                // Left Middle Edge
                path.addLine(to:CGPoint(x: middle / 2, y: spacing + 100))
                // Left bottom edge
                path.addLine(to:CGPoint(x: middle - topWidth, y: bottomHeight))
                // Middle arrow
                path.addLine(to:CGPoint(x: middle, y: bottomHeight / 1.5 + spacing))
                // right bottom edge
                path.addLine(to:CGPoint(x: middle + topWidth, y: bottomHeight))
                // Right Top
                path.addLine(to:CGPoint(x: middle * 1.5, y: spacing))
                
                
                //path.move(to: CGPoint(x: 20, y: 50))
                    
                //path.addQuadCurve(to: CGPoint(x: 35, y: 30), control: CGPoint(x: 50, y: 50))
                
            }//.padding(.vertical, 150.0)
            
            /*
            Path { path in
             path.move(to: CGPoint(x: 20, y: 50))
             //path.addQuadCurve(to: CGPoint(x: 50, y: 20), control: CGPoint(x: 20, y: 20))
            path.addQuadCurve(to: CGPoint(x: 35, y: 30), control: CGPoint(x: 50, y: 50))
            //path.addQuadCurve(to: CGPoint(x: 35, y: 20), control: CGPoint(x: 50, y: 20))

             path.addLine(to: CGPoint(x: 90, y: 20))
             //path.addQuadCurve(to: CGPoint(x: 100, y: 30), control: CGPoint(x: 100, y: 20))
            // path.addQuadCurve(to: CGPoint(x: 120, y: 50), control: CGPoint(x: 100, y: 50))
                
                
                
                
             path.addLine(to: CGPoint(x: 230, y: 50))
             path.addQuadCurve(to: CGPoint(x: 250, y: 30), control: CGPoint(x: 250, y: 50))
             path.addQuadCurve(to: CGPoint(x: 260, y: 20), control: CGPoint(x: 250, y: 20))

                
             path.addLine(to: CGPoint(x: 300, y: 20))
             //path.addQuadCurve(to: CGPoint(x: 330, y: 50), control: CGPoint(x: 330, y: 20))
             path.addLine(to: CGPoint(x: 330, y: 600))
            // path.addQuadCurve(to: CGPoint(x: 300, y: 630), control: CGPoint(x: 330, y: 630))
             path.addLine(to: CGPoint(x: 50, y: 630))
             //path.addQuadCurve(to: CGPoint(x: 20, y: 600), control: CGPoint(x: 20, y: 630))
             path.addLine(to: CGPoint(x: 20, y: 50))
            }.foregroundColor(Color(red: 30/255, green: 32/255, blue: 36/255))
            */
        }
    }
}

struct BookmarkSymbol_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkSymbol()
    }
}


/*
Path { path in
    let width = min(geometry.size.width, geometry.size.height)
    let height = width * 0.75
    let spacing = width * 0.030
    let middle = width / 2
    let topWidth = 0.226 * width
    let topHeight = 0.488 * height
    
    path.addLines([
        CGPoint(x: middle, y: spacing),
        CGPoint(x: middle - topWidth, y: topHeight - spacing),
        CGPoint(x: middle - topWidth, y: topHeight - spacing),
        CGPoint(x: middle, y: topHeight / 2 + spacing),
        CGPoint(x: middle + topWidth, y: topHeight - spacing),
        CGPoint(x: middle, y: spacing)
    ])
}
*/
