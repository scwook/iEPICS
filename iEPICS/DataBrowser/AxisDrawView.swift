//
//  AxisDrawView.swift
//  iEPICS
//
//  Created by ctrl user on 23/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class AxisDrawView: UIView {

    let yAxisDataRange: CGFloat = 200
    let xOffset: CGFloat = 10
    let yOffset: CGFloat = 10
    let date = Date()
    
    let axisLineWidth: CGFloat = 1.0
    let legendColorAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]

    override func draw(_ rect: CGRect) {
        // Drawing code
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

        if( dataBrowserModel.elementCount > 1 ) {
            DrawArrayXAxisTick()
            DrawArrayYAxisTick()
        }
        else {
            DrawXAxisTick()
            DrawYAxisTick()
        }
    }
    
    private func DrawXAxisTick() {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let tickPath = UIBezierPath()

        let tickInfo = dataBrowserModel.getDxInfoValue()
        
        let viewSize = dataBrowserModel.drawViewSize
        var movePositionX = viewSize.origin.x + viewSize.width
        let movePositionY = viewSize.origin.y + viewSize.height
        
        let bigTickScale = 5 * tickInfo.dt
        
        let date = Date()
        let currentTime = date.timeIntervalSince1970 + dataBrowserModel.timeOffset
        
        let currentPositionOffset = CGFloat(Int(currentTime) % bigTickScale) * tickInfo.dx
        movePositionX -= CGFloat(currentPositionOffset)
        let originX = movePositionX
        
        let currentTimeOffset = Int(currentTime) % bigTickScale
        let formatter = DateFormatter()
        
        if(tickInfo.dt * 5 <= 60) {
            formatter.dateFormat = "HH:mm:ss"
            
        }
        else {
            formatter.dateFormat = "HH:mm"
        }
        
        let timeDate = date.addingTimeInterval(dataBrowserModel.timeOffset)
        
        var count = 0
        var idx = 0
        
        var timeString: Date = timeDate
        var legendLabel: String = "yyyy-MM-dd"
        let size: CGSize = legendLabel.size(withAttributes: nil)
        
        while( movePositionX > viewSize.origin.x ) {
            
            if( count % 5 == 0) {
                tickPath.move(to: CGPoint(x: movePositionX, y: movePositionY))
                tickPath.addLine(to: CGPoint(x: movePositionX, y: movePositionY + CGFloat(10)))
                
                timeString = timeDate.addingTimeInterval(-TimeInterval(idx * bigTickScale + currentTimeOffset))
                legendLabel = formatter.string(from: timeString)

                let position = CGPoint(x: movePositionX - 20, y:movePositionY + CGFloat(10))
                if( position.x > size.width) {
                    legendLabel.draw(at: CGPoint(x: movePositionX - 20, y: movePositionY + CGFloat(10)), withAttributes: legendColorAttributes)
                }
                
                idx += 1
            }
            else {
                tickPath.move(to: CGPoint(x: movePositionX, y: movePositionY))
                tickPath.addLine(to: CGPoint(x: movePositionX, y: movePositionY + CGFloat(5)))
            }
            
            movePositionX -= tickInfo.dx * CGFloat(tickInfo.dt)
            count += 1
        }
        
        count = 0
        idx = 0
        movePositionX = originX
        
        while( movePositionX < viewSize.origin.x + viewSize.width ) {
            
            if( count % 5 == 0) {
                tickPath.move(to: CGPoint(x: movePositionX, y: movePositionY))
                tickPath.addLine(to: CGPoint(x: movePositionX, y: movePositionY + CGFloat(10)))

                idx += 1
            }
            else {
                tickPath.move(to: CGPoint(x: movePositionX, y: movePositionY))
                tickPath.addLine(to: CGPoint(x: movePositionX, y: movePositionY + CGFloat(5)))
            }
            
            movePositionX += tickInfo.dx * CGFloat(tickInfo.dt)
            count += 1
        }
        
        tickPath.lineWidth = axisLineWidth
        UIColor.black.set()
        tickPath.stroke()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.string(from: timeString)
        dayString.draw(at: CGPoint(x: 5, y: movePositionY + CGFloat(10)), withAttributes: legendColorAttributes)
    }
    
    private func DrawYAxisTick() {
        
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let tickPath = UIBezierPath()
        let tickInfo = dataBrowserModel.getDyInfoValue()
        
        let viewSize = dataBrowserModel.drawViewSize
        let movePositionX = viewSize.origin.x
        var originY = viewSize.origin.y + viewSize.height
        let value1 = dataBrowserModel.value1
        
        var legendLabelScale = tickInfo.scale
        
        // Exponential Express
        if( tickInfo.exp > 3 ) {
            for _ in 0 ..< tickInfo.exp {
                legendLabelScale /= 10
            }
            
            legendLabelScale = floor(legendLabelScale * 100) / 100
            
            let baseLabel = "10"
            let exponentialLabel = String(tickInfo.exp)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)]
            
            baseLabel.draw(at: CGPoint(x: 5, y: 30), withAttributes: nil)
            exponentialLabel.draw(at: CGPoint(x: 10, y: 16), withAttributes: attributes)
        }
        else if( tickInfo.exp < -3 ) {
            for _ in tickInfo.exp ..< 0  {
                legendLabelScale *= 10
            }
            
            legendLabelScale = floor(legendLabelScale * 10000) / 10000
            
            let baseLabel = "10"
            let exponentialLabel = String(tickInfo.exp)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)]
            
            baseLabel.draw(at: CGPoint(x: 5, y: 30), withAttributes: nil)
            exponentialLabel.draw(at: CGPoint(x: 10, y: 16), withAttributes: attributes)
        }
        
        // Gesture Moving Value
        let offset = value1 * tickInfo.dy
        originY += offset
        
        let context = UIGraphicsGetCurrentContext()!

        //var idx = 0
        var count = 0
        while( originY > viewSize.origin.y ) {
            
            if( originY < viewSize.origin.y + viewSize.height ) {
                if( count % 5 == 0) {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(10), y: originY))
                    
//                    let legendLabel = String(format: "%.2f", CGFloat(count) * legendLabelScale)
                    let legendLabel = String(describing: CGFloat(count) * legendLabelScale)
                    let size: CGSize = legendLabel.size(withAttributes: nil)
                    
                    context.saveGState()
                    context.translateBy(x: movePositionX - 25, y: originY + size.width / 2)
                    context.rotate(by: CGFloat(-Double.pi / 2))
                    context.setFillColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
                    legendLabel.draw(at: CGPoint.zero, withAttributes: legendColorAttributes)
                    context.restoreGState()
                    //idx += 1
                }
                else {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(5.0), y: originY))
                }
            }
            
            originY -= tickInfo.dy * tickInfo.scale
            count += 1
        }
        
        originY = viewSize.origin.y + viewSize.height
        originY += offset + tickInfo.dy * tickInfo.scale
        
        count = 1
        //idx = 0
        while( originY < viewSize.origin.y + viewSize.height) {
            if( originY > viewSize.origin.y) {
                if( count % 5 == 0) {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(10), y: originY))
                    
                    let legendLabel = String(describing: CGFloat(-count) * legendLabelScale)
                    let size: CGSize = legendLabel.size(withAttributes: nil)
                    
                    context.saveGState()
                    context.translateBy(x: movePositionX - 25, y: originY + size.width / 2)
                    context.rotate(by: CGFloat(-Double.pi / 2))
                    
                    legendLabel.draw(at: CGPoint.zero, withAttributes: legendColorAttributes)
                    
                    context.restoreGState()
                    //idx += 1
                }
                else {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(5.0), y: originY))
                }
            }
            
            originY += tickInfo.dy * tickInfo.scale
            count += 1
        }
        
        tickPath.lineWidth = axisLineWidth
        UIColor.black.set()
        tickPath.stroke()
    }
    
    private func DrawArrayXAxisTick() {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let tickPath = UIBezierPath()
        let tickInfo = dataBrowserModel.getArrayDxInfoValue()
        
        let viewSize = dataBrowserModel.drawViewSize
        var movePositionX = viewSize.origin.x + 0.5 // line width / 2
        let movePositionY = viewSize.origin.y + viewSize.height
        
        let bigTickScale = 5 * tickInfo.dt
        var legendLabel: String
        let originX = movePositionX
        
        var count = 0
        var idx = 0
        
        while( movePositionX < viewSize.origin.x + viewSize.width) {
            
            if( count % 5 == 0) {
                tickPath.move(to: CGPoint(x: movePositionX, y: movePositionY))
                tickPath.addLine(to: CGPoint(x: movePositionX, y: movePositionY + CGFloat(10)))
                
                legendLabel = String(describing: Int(bigTickScale * idx))
                let size: CGSize = legendLabel.size(withAttributes: nil)
                
                legendLabel.draw(at: CGPoint(x: movePositionX - size.width / 2, y: movePositionY + CGFloat(10)), withAttributes: legendColorAttributes)
                
                idx += 1
            }
            else {
                tickPath.move(to: CGPoint(x: movePositionX, y: movePositionY))
                tickPath.addLine(to: CGPoint(x: movePositionX, y: movePositionY + CGFloat(5)))
            }
            
            movePositionX += tickInfo.dx * CGFloat(tickInfo.dt)
            count += 1
        }
        
        tickPath.lineWidth = axisLineWidth
        UIColor.black.set()
        tickPath.stroke()
    }
    
    private func DrawArrayYAxisTick() {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let tickPath = UIBezierPath()
        let tickInfo = dataBrowserModel.getDyInfoValue()
        
        let viewSize = dataBrowserModel.drawViewSize
        let movePositionX = viewSize.origin.x
        var originY = viewSize.origin.y + viewSize.height
        let value1 = dataBrowserModel.value1
        
        var legendLabelScale = tickInfo.scale
        
        // Exponential Express
        if( tickInfo.exp > 3 ) {
            for i in 0 ..< tickInfo.exp {
                legendLabelScale /= 10
            }
            
            legendLabelScale = floor(legendLabelScale * 100) / 100
            
            let baseLabel = "10"
            let exponentialLabel = String(tickInfo.exp)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)]
            
            baseLabel.draw(at: CGPoint(x: 5, y: 30), withAttributes: legendColorAttributes)
            exponentialLabel.draw(at: CGPoint(x: 18, y: 26), withAttributes: attributes)
        }
        
        // Gesture Moving Value
        let offset = value1 * tickInfo.dy
        originY += offset
        
        let context = UIGraphicsGetCurrentContext()!
        
        //var idx = 0
        var count = 0
        while( originY > viewSize.origin.y ) {
            
            if( originY < viewSize.origin.y + viewSize.height ) {
                if( count % 5 == 0) {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(10), y: originY))
                    
                    let legendLabel = String(describing: CGFloat(count) * legendLabelScale)
                    let size: CGSize = legendLabel.size(withAttributes: nil)
                    
                    context.saveGState()
                    context.translateBy(x: movePositionX - 25, y: originY + size.width / 2)
                    context.rotate(by: CGFloat(-Double.pi / 2))
                    
                    legendLabel.draw(at: CGPoint.zero, withAttributes: legendColorAttributes)
                    
                    context.restoreGState()
                    //idx += 1
                }
                else {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(5.0), y: originY))
                }
            }
            
            originY -= tickInfo.dy * tickInfo.scale
            count += 1
        }
        
        originY = viewSize.origin.y + viewSize.height
        originY += offset + tickInfo.dy * tickInfo.scale
        
        count = 1
        //idx = 0
        while( originY < viewSize.origin.y + viewSize.height) {
            if( originY > viewSize.origin.y) {
                if( count % 5 == 0) {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(10), y: originY))
                    
                    let legendLabel = String(describing: CGFloat(-count) * legendLabelScale)
                    let size: CGSize = legendLabel.size(withAttributes: nil)
                    
                    context.saveGState()
                    context.translateBy(x: movePositionX - 25, y: originY + size.width / 2)
                    context.rotate(by: CGFloat(-Double.pi / 2))
                    
                    legendLabel.draw(at: CGPoint.zero, withAttributes: legendColorAttributes)
                    
                    context.restoreGState()
                    //idx += 1
                }
                else {
                    tickPath.move(to: CGPoint(x: movePositionX, y: originY))
                    tickPath.addLine(to: CGPoint(x: movePositionX - CGFloat(5.0), y: originY))
                }
            }
            
            originY += tickInfo.dy * tickInfo.scale
            count += 1
        }
        
        tickPath.lineWidth = axisLineWidth
        UIColor.black.set()
        tickPath.stroke()
    }
    
    private func ValueToPixel(value: CGFloat) -> Int {
        
        let viewHeight = bounds.height
        
        let scale = viewHeight / yAxisDataRange
        let pixel = Int(value * scale)
        
        return pixel
    }
}

extension CGFloat {
    func roundTo(places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
