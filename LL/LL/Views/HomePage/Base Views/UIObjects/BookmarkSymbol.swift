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
                let spacing = width * 0.035
                let middle = width / 2
                let topWidth = 0.25 * width
                let bottomHeight = 1.25 * height
                
                path.addLines([
                    // Left Top
                    CGPoint(x: middle / 2, y: spacing),
                    // Left bottom edge
                    CGPoint(x: middle - topWidth, y: bottomHeight),
                    // Middle arrow
                    CGPoint(x: middle, y: bottomHeight / 1.5 + spacing),
                    // right bottom edge
                    CGPoint(x: middle + topWidth, y: bottomHeight),
                    // Right Top
                    CGPoint(x: middle * 1.5, y: spacing)
                ])
                // Add a curve in top left ?????
                path.addCurve(to: CGPoint(x: middle / 2, y: spacing), control1: CGPoint(x: middle, y: spacing), control2: CGPoint(x: middle, y: spacing))
                
            }
            
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
