//
//  DataBrowserModel.swift
//  iEPICS
//
//  Created by ctrl user on 23/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class DataBrowserModel {
    
    static let DataBrowserModelSingleTon = DataBrowserModel()
    
    private init() {
        
    }
    
    private let dxNumberOfMinTick: CGFloat = 15
    //    private let dxNumberOfMaxTick: UInt8 = 30
    private let dyNumberOfMinTick: CGFloat = 15
    private let dyNumberOfMaxTick: CGFloat = 30
    
    public let refreshRate: UInt32 = 1
    public var timeRange: CGFloat = 60
    public var timeOffset: TimeInterval = 0
    public var value1: CGFloat = 0
    public var value2: CGFloat = 1
    public var drawViewSize: CGRect = CGRect.zero
    public var axisViewSize: CGRect = CGRect.zero
    
    public var isLongPressed: Bool = false
    public var longPressedLocation: CGPoint?
    
    public var scale: CGFloat = 1
    
    public var elementCount: Int = 1
    
    public func getDxInfoValue() -> (dx: CGFloat, dt: Int){
        
        let pixelPerSecond = drawViewSize.width / timeRange
        let maxPixelPerTick = drawViewSize.width / dxNumberOfMinTick
        
        var count = 0;
        var pixelPerTick = pixelPerSecond
        
        while( pixelPerTick < maxPixelPerTick ) {
            pixelPerTick *= 2
            count += 1
        }
        
        let timePerTick = Int(truncating: pow(2, count) as NSDecimalNumber)
       
        let returnValue = (dx: pixelPerSecond, dt: timePerTick)
        return returnValue
    }
    
    public func getDyInfoValue() -> (dy: CGFloat, scale: CGFloat, exp: Int) {
        
        let valueRange = abs(value2 - value1)
        let pixelPerValue = drawViewSize.height / valueRange
        
        var count = 0;
        var pixelPerTick = pixelPerValue
        var valuePerTick: CGFloat = 1
        
        let maxPixelPerTick = drawViewSize.height / dyNumberOfMinTick
        let minPixelPerTick = drawViewSize.height / dyNumberOfMaxTick
        
        if( pixelPerValue > maxPixelPerTick ) {
            while( pixelPerTick > maxPixelPerTick ) {
                pixelPerTick /= 2
                count += 1
                valuePerTick = pow(2.0, -CGFloat(count))
            }
        }
        else {
            while( pixelPerTick < minPixelPerTick ) {
                pixelPerTick *= 2
                count += 1
                valuePerTick = pow(2.0, CGFloat(count))
            }
        }
        
        scale = valuePerTick
        
        var exponentialReference = (valueRange + abs(value1 + value2)) / 2
        var exponentValue: Int = 0
        
        if( exponentialReference < 1 ) {
            while( exponentialReference <= 0.1 ) {
                exponentialReference *= 10
                exponentValue -= 1
            }
        }
        else {
            while( exponentialReference >= 10 ) {
                exponentialReference /= 10
                exponentValue += 1
            }
        }
        
        let returnValue = (dy: pixelPerValue, scale: valuePerTick, exp: exponentValue)
        return returnValue
    }
    
    public func getArrayDxInfoValue() -> (dx: CGFloat, dt: Int) {
        let pixelPerCount = drawViewSize.width / CGFloat(elementCount)
        let maxPixelPerTick = drawViewSize.width / dxNumberOfMinTick
        
        var count = 0;
        var pixelPerTick = pixelPerCount
        
        while( pixelPerTick < maxPixelPerTick ) {
            pixelPerTick *= 2
            count += 1
        }
        
        let countPerTick = Int(truncating: pow(2, count) as NSDecimalNumber)
        
        return (pixelPerCount, countPerTick)
    }
    
    public func getArrayDyInfoValue() -> (dy: CGFloat, dt: CGFloat, exp: Int) {
    
        let valueRange = abs(value2 - value1)
        let pixelPerValue = drawViewSize.height / valueRange
        
        var count = 0;
        var pixelPerTick = pixelPerValue
        var valuePerTick: CGFloat = 1
        
        let maxPixelPerTick = drawViewSize.height / dyNumberOfMinTick
        let minPixelPerTick = drawViewSize.height / dyNumberOfMaxTick
        
        if( pixelPerValue > maxPixelPerTick ) {
            while( pixelPerTick > maxPixelPerTick ) {
                pixelPerTick /= 2
                count += 1
                valuePerTick = pow(2.0, -CGFloat(count))
            }
        }
        else {
            while( pixelPerTick < minPixelPerTick ) {
                pixelPerTick *= 2
                count += 1
                valuePerTick = pow(2.0, CGFloat(count))
            }
        }
        
        scale = valuePerTick
        
        var exponentialReference = (valueRange + abs(value1 + value2)) / 2
        var exponentValue: Int = 0
        
        if( exponentialReference < 1 ) {
            while( exponentialReference <= 0.1 ) {
                exponentialReference *= 10
                exponentValue -= 1
            }
        }
        else {
            while( exponentialReference >= 10 ) {
                exponentialReference /= 10
                exponentValue += 1
            }
        }
        
        return (pixelPerValue, scale, exponentValue)
    }
    
    public func setAutoViewSize(_ value: Array<Double>?) -> Void {
        if let data = value {
            if (!data.isEmpty) {
                let maxValue = data.max()!
                let minValue = data.min()!
                
                value1 = CGFloat(minValue - abs(minValue) * 0.1)
                value2 = CGFloat(maxValue + abs(maxValue) * 0.1)
            }
        }
    
        timeOffset = 0

    }
}

