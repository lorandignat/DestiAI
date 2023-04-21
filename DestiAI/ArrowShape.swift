//
//  ArrowShape.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import SwiftUI

struct ArrowShape: Shape {

  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: 0,
                          y: 0))
    path.addLine(to: CGPoint(x: 0, y: 15))
    path.addCurve(to: CGPoint(x: 10, y: 20),
                  control1: CGPoint(x: 0,
                                    y: 20),
                  control2: CGPoint(x: 5,
                                    y: 20))
    path.addLine(to: CGPoint(x: rect.maxX / 2, y: 20))
    
    path.move(to: CGPoint(x: rect.maxX,
                          y: 0))
    path.addLine(to: CGPoint(x: rect.maxX, y: 15))
    path.addCurve(to: CGPoint(x: rect.maxX - 10, y: 20),
                  control1: CGPoint(x: rect.maxX,
                                    y: 20),
                  control2: CGPoint(x: rect.maxX - 5,
                                    y: 20))
    path.addLine(to: CGPoint(x: rect.maxX / 2, y: 20))
    
    path.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY - 40))
    path.addLine(to: CGPoint(x: rect.maxX / 2 - 15, y: rect.maxY - 40))
    path.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY - 20))
    path.addLine(to: CGPoint(x: rect.maxX / 2 + 15, y: rect.maxY - 40))
    path.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY - 40))
    
    return path
  }
}


struct CurveArrowShape: Shape {

  var mirrored = false
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: mirrored ? rect.maxX : 0,
                          y: rect.maxY * 0.1))
    
    path.addLine(to: CGPoint(x: mirrored ? rect.maxX : 0,
                             y: rect.maxY * 0.7))
    path.addCurve(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.15 : 0.15),
                              y: rect.maxY * 0.8),
                  control1: CGPoint(x: rect.maxX * (mirrored ? 1: 0),
                                    y: rect.maxY * 0.8),
                  control2: CGPoint(x: rect.maxX * (mirrored ? 1: 0),
                                    y: rect.maxY * 0.8))
    
    path.addLine(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.8 : 0.8),
                             y: rect.maxY * 0.8))
    path.addCurve(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                              y: rect.maxY * 0.85),
                  control1: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                                    y: rect.maxY * 0.8),
                  control2: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                                    y: rect.maxY * 0.8))

    let arrowhead = Path() { arrowheadPath in
      arrowheadPath.move(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                                     y: rect.maxY * 0.85))
      arrowheadPath.addLine(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                               y: rect.maxY * 0.86))
      arrowheadPath.addLine(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95) - 15,
                               y: rect.maxY * 0.86))
      arrowheadPath.addLine(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                               y: rect.maxY * 0.86 + 20))
      arrowheadPath.addLine(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95) + 15,
                               y: rect.maxY * 0.86))
      arrowheadPath.addLine(to: CGPoint(x: rect.maxX * (mirrored ? 1 - 0.95 : 0.95),
                               y: rect.maxY * 0.86))
      arrowheadPath.closeSubpath()
    }

    path.addPath(arrowhead)
    
    return path
  }
}
