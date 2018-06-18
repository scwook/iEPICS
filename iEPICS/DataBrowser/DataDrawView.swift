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
    var time = [Int]()
    var nSecTime = [CGFloat]()
    
    var archiveData = [Double]()
    var archiveTime = [Int]()
    var archiveNSecTime = [CGFloat]()
    
    private var position = [Int : Double]()
    var probeIndex: (x: CGFloat?, data: Double?) = (nil, nil)
//    var arrayData = [Double]()
    
    let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]

    let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

    //var xAxisScale: CGFloat = 100
    //var originPixel: CGPoint = CGPoint(x: 0, y: 0)
    //var pixelPerDeltaT = 10
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let elementCount = dataBrowserModel.elementCount
        if (elementCount > 1) {
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
    
/* First version draw function */
//    private func DrawValue() {
//        let plot = UIBezierPath()
//
//        var timeOffset: Int = 0
//        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
//        let dtInfo = dataBrowserModel.getDxInfoValue()
//        let dx = dtInfo.dx
//        let startPoint: CGPoint = CGPoint(x: self.bounds.width, y: self.bounds.height - ValueToPixel(value: CGFloat(data[data.count - 1])))
//
//        if (data.count > 0) {
//            plot.move(to: startPoint)
//            var index = data.count
//            let currentTime = Date()
//            timeOffset = Int(currentTime.timeIntervalSince1970 + dataBrowserModel.timeOffset) - time[index - 1]
//
//            position.removeAll()
//            for i in 0..<index {
//                let dataLocation = CGPoint(x: startPoint.x - dx * CGFloat(i + timeOffset), y: bounds.height - ValueToPixel(value: CGFloat(data[index-1])))
//                plot.addLine(to: dataLocation)
//
//                //position.append(Int(dataLocation.x))
//                position.insert(Int(dataLocation.x), at: 0)
//                if let probe = probeIndex, i == probeIndex {
//                    let probeLocation = CGPoint(x: startPoint.x - dx * CGFloat(index - 1 + timeOffset), y: bounds.height - ValueToPixel(value: CGFloat(data[probe])))
//                    let circle = UIBezierPath(arcCenter: probeLocation, radius: 6, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
//
////                    UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0).setFill()
//                    UIColor.black.setFill()
//                    circle.fill()
//
////                    UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0).set()
//                    let valueString = String(describing: data[probe])
//                    valueString.draw(at: CGPoint(x: probeLocation.x + 10, y: probeLocation.y - 18), withAttributes: attributes)
//                }
//
//                index = index - 1
//            }
//
//            //position = position.reversed()
//
////            UIColor.black.set()
//            UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0).set()
//            plot.lineJoinStyle = .round
//            plot.lineWidth = 2.5
//            plot.stroke()
//        }
//
//    }
    
    /* Second version draw function */
    private func DrawValue() {
        let drawData = archiveData + data
        let drawDataTime = archiveTime + time
        let drawDataNSecTime = archiveNSecTime + nSecTime
    
        let plot = UIBezierPath()
        
        var drawTimeOffset: CGFloat = 0.0
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        let dtInfo = dataBrowserModel.getDxInfoValue()
        let dx = dtInfo.dx
        
        if (drawData.count > 0) {
            var index = drawData.count - 1
            
            // Plotting line will be started form right to left of view.
            let startPoint = CGPoint(x: self.bounds.width, y: self.bounds.height - ValueToPixel(value: CGFloat(drawData[index])))
            plot.move(to: startPoint)
            
            var dataLocation = startPoint
            position.removeAll()
            for _ in 0..<drawData.count {
                drawTimeOffset = dx * (CGFloat(dataBrowserModel.timeOffset ) - CGFloat(drawDataTime[index]) - drawDataNSecTime[index])

                dataLocation = CGPoint(x: startPoint.x - drawTimeOffset, y: bounds.height - ValueToPixel(value: CGFloat(drawData[index])))
                plot.addLine(to: dataLocation)
                
//                print(drawData.count)
                
                // Insert data position and it's data to find when navigation line is moved on view
                position[Int(dataLocation.x)] = drawData[index]

                
                if dataLocation.x < -1 {
                    break
                }
                
                index = index - 1
            }
            
            //position = position.reversed()
            
            //            UIColor.black.set()
            UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0).set()
            plot.lineJoinStyle = .round
            plot.lineWidth = 2.5
            plot.stroke()
        }
        
    }
    
    private func DrawArrayValue() {
        let plot = UIBezierPath()
        let dx = self.bounds.width / CGFloat(data.count)
        
        let startPoint: CGPoint = CGPoint(x: 0, y: self.bounds.height - ValueToPixelArray(value: CGFloat(data[0])))
        
        plot.move(to: startPoint)
        
        for i in 1 ..< data.count {
            let nextPoint = CGPoint(x: startPoint.x + dx * CGFloat(i), y: self.bounds.height - ValueToPixelArray(value: CGFloat(data[i])))
            
            plot.addLine(to: nextPoint)
        }
        
        //        UIColor.black.set()
        UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0).set()
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
//        UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0).set()
        UIColor.black.set()
        probeLine.lineWidth = 2.0
        probeLine.stroke()
        
        if let data = position[Int(location.x)] {
            let probeLocation = CGPoint(x: location.x, y: bounds.height - ValueToPixel(value: CGFloat(data)))
            let circle = UIBezierPath(arcCenter: probeLocation, radius: 6, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            UIColor.black.setFill()
            circle.fill()
            
            let valueString = String(describing: data)
            valueString.draw(at: CGPoint(x: probeLocation.x + 10, y: probeLocation.y - 18), withAttributes: attributes)
            
            probeIndex.x = location.x
            probeIndex.data = data
        
        }
        else if let posX = probeIndex.x, let data = probeIndex.data {
            let probeLocation = CGPoint(x: posX, y: bounds.height - ValueToPixel(value: CGFloat(data)))
            let circle = UIBezierPath(arcCenter: probeLocation, radius: 6, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            UIColor.black.setFill()
            circle.fill()
            
            let valueString = String(describing: data)
            valueString.draw(at: CGPoint(x: probeLocation.x + 10, y: probeLocation.y - 18), withAttributes: attributes)
        }
    }
    
    private func DrawDashLine() -> Void {
        let pattern: Array<CGFloat> = [2, 5]
        let dashLine = UIBezierPath()
        dashLine.move(to: CGPoint(x: 100, y: 100))
        dashLine.addLine(to: CGPoint(x: 200, y: 200))
        dashLine.setLineDash(pattern, count: 2, phase: 0)
        dashLine.lineWidth = 1.5
        UIColor.black.set()
        dashLine.stroke()
    }
    
    private func ValueToPixel(value: CGFloat) -> CGFloat {
        
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
//        let dtInfo = dataBrowserModel.getDyInfoValue()
        let dtInfo = dataBrowserModel.getDyInfoValue()
        let offsetValue = dataBrowserModel.value1
        let pixel = (value - offsetValue) * dtInfo.dy
        
        return pixel
    }
    
    private func ValueToPixelArray(value: CGFloat) -> CGFloat {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
//        let dyInfo = dataBrowserModel.getArrayDyInfoValue()
        let dyInfo = dataBrowserModel.getArrayDyInfoValue()
        let offsetValue = dataBrowserModel.value1

        let pixel = (value - offsetValue) * dyInfo.dy
        
        return pixel
    }
}
