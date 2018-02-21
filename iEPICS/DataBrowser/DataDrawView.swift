//
//  DataDrawView.swift
//  iEPICS
//
//  Created by ctrl user on 23/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class DataDrawView: UIView {

    var data = [Double]()
    var time: Array<Int> = [Int]()
    var position: Array<Int> = [Int]()
    var probeIndex: Int? = nil
    var arrayData = [Double]()
    
    //var xAxisScale: CGFloat = 100
    //var originPixel: CGPoint = CGPoint(x: 0, y: 0)
    //var pixelPerDeltaT = 10
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if (arrayData.count > 1) {
            DrawArrayValue()
        }
        else {
            if (data.count > 0) {
                DrawValue()
                //DrawDashLine()
                let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
                if let location = dataBrowserModel.longPressedLocation, dataBrowserModel.isLongPressed {
                    DrawNavigationLine(location)
                }
            }
        }
        
        DrawAxis()
    }
    
    private func DrawAxis() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        UIColor.black.set()
        path.lineWidth = 3.0
        path.stroke()
    }
    
    private func DrawValue() {
        let plot = UIBezierPath()
        
        var timeOffset: Int = 0
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let dtInfo = dataBrowserModel.getDxInfoValue()
        let dx = dtInfo.dx
        let startPoint: CGPoint = CGPoint(x: self.bounds.width, y: self.bounds.height - ValueToPixel(value: CGFloat(data[data.count - 1])))
        
        if (data.count > 0) {
            plot.move(to: startPoint)
            var index = data.count
            let currentTime = Date()
            timeOffset = Int(currentTime.timeIntervalSince1970 + dataBrowserModel.timeOffset) - time[index - 1]
            
            position.removeAll()
            for i in 0..<index {
                let dataLocation = CGPoint(x: startPoint.x - dx * CGFloat(i + timeOffset), y: bounds.height - ValueToPixel(value: CGFloat(data[index-1])))
                plot.addLine(to: dataLocation)
                
                //position.append(Int(dataLocation.x))
                position.insert(Int(dataLocation.x), at: 0)
                if let probe = probeIndex, i == probeIndex {
                    let probeLocation = CGPoint(x: startPoint.x - dx * CGFloat(index - 1 + timeOffset), y: bounds.height - ValueToPixel(value: CGFloat(data[probe])))
                    let circle = UIBezierPath(arcCenter: probeLocation, radius: 5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                    
                    UIColor.red.setFill()
                    circle.fill()
                    
                    let valueString = String(describing: data[probe])
                    valueString.draw(at: probeLocation, withAttributes: nil)
                    
                }
                
                index = index - 1
            }
            
            //position = position.reversed()
            
            UIColor.black.set()
            plot.lineJoinStyle = .round
            plot.lineWidth = 2
            plot.stroke()
        }
        
    }
    
    private func DrawArrayValue() {
        let plot = UIBezierPath()
        let dx = self.bounds.width / CGFloat(arrayData.count)
        
        let startPoint: CGPoint = CGPoint(x: 0, y: self.bounds.height - ValueToPixelArray(value: CGFloat(arrayData[0])))
        
        plot.move(to: startPoint)
        
        for i in 1 ..< arrayData.count {
            let nextPoint = CGPoint(x: startPoint.x + dx * CGFloat(i), y: self.bounds.height - ValueToPixelArray(value: CGFloat(arrayData[i])))
            
            plot.addLine(to: nextPoint)
        }
        
        UIColor.black.set()
        plot.lineJoinStyle = .round
        plot.lineWidth = 2
        plot.stroke()
    }
    
    public func DrawNavigationLine(_ location: CGPoint) -> Void {
        let pattern: Array<CGFloat> = [5, 5]
        let probeLine = UIBezierPath()
        probeLine.move(to: CGPoint(x: location.x, y: 0))
        probeLine.addLine(to: CGPoint(x: location.x, y: self.bounds.height))
        probeLine.setLineDash(pattern, count: 2, phase: 0)
        UIColor.red.set()
        probeLine.lineWidth = 2.0
        probeLine.stroke()
        
        if let index = position.index(of: Int(location.x)) {
            probeIndex = index
        }
        
    }
    
    private func DrawDashLine() -> Void {
        let pattern: Array<CGFloat> = [2, 5]
        let dashLine = UIBezierPath()
        dashLine.move(to: CGPoint(x: 100, y: 100))
        dashLine.addLine(to: CGPoint(x: 200, y: 200))
        dashLine.setLineDash(pattern, count: 2, phase: 0)
        dashLine.lineWidth = 1.5
        UIColor.gray.set()
        dashLine.stroke()
    }
    
    private func ValueToPixel(value: CGFloat) -> CGFloat {
        
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let dtInfo = dataBrowserModel.getDyInfoValue()
        let offsetValue = dataBrowserModel.value1
        let pixel = (value - offsetValue) * dtInfo.dy
        
        return pixel
    }
    
    private func ValueToPixelArray(value: CGFloat) -> CGFloat {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let dyInfo = dataBrowserModel.getArrayDyInfoValue()
        let offsetValue = dataBrowserModel.value1

        let pixel = (value - offsetValue) * dyInfo.dy
        
        return pixel
    }
}
