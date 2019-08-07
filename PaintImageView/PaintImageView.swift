//
//  PaintImageView.swift
//  PaintImageView
//
//  Created by ios on 2018/7/31.
//  Copyright © 2018年 ios. All rights reserved.
//

import UIKit

struct FillLineInfo : Hashable {
    let lineNumber:Int
    var xLeft:Int
    var xRight:Int
}
typealias ColorValue = (red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8)
class PaintImageView: UIImageView {
    var newColor:UIColor = .red //需要填充的新颜色
    var unchangeableColors = [UIColor]()
//    (693.5, 217.0)  (223.0, 623.5)
    var seedPointArray = [CGPoint.init(x: 541.5, y: 214.5),
                          CGPoint.init(x: 449.0, y: 87.0),
                          CGPoint.init(x: 693.0, y: 217.0),
                          CGPoint.init(x: 223, y: 217.0),
    ]
    
    var isFindSeedPoint = false
    var isEndCurrentFill = false
    
    
    private var pixels:Array<UInt32> //像素点的集合
    private var imageSize = CGSize.zero //图片的大小 width height都是整数
    private var seedPointList = StackList<CGPoint>() //种子点的栈列表
    private var scanedLines = [Int:FillLineInfo]() //扫描过的扫描线的信息
    var colorTolorance = 150 //颜色差值
    
    override init(image: UIImage?) {
        self.pixels = Array<UInt32>()
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        self.pixels = Array<UInt32>()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.pixels = Array<UInt32>()
        super.init(coder: aDecoder)
    }
    
    override var contentMode: UIView.ContentMode {
        didSet {
            if contentMode != .scaleToFill {
                self.contentMode = .scaleToFill
            }
        }
    }
    
    /**
     (541.5, 214.5)
     (449.0, 87.0)
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 , let touch = touches.first{
            let point = touch.location(in: self)
            floodFill(from: point)
            print(point)
        }
    }
    //MARK: private method
    /// 填充颜色
    ///
    /// - Parameters:
    ///   - point: 种子点
    ///   - color: 填充颜色
    private func floodFill(from point:CGPoint) {
        if let imageRef = image?.cgImage  {
            let width = imageRef.width
            let height = imageRef.height
            let widthScale = CGFloat(width) / bounds.width
            let heightScale = CGFloat(height) / bounds.height
            //把相对于view的touch point 转换成image的像素点的坐标点
            let realPoint = CGPoint(x: point.x * widthScale, y: point.y * heightScale)
            scanedLines = [:]
            imageSize = CGSize(width: width, height: height)
            pixels = Array<UInt32>(repeating: 0, count: width * height)
            let colorSpace = CGColorSpaceCreateDeviceRGB() //像素点的颜色空间
            let bitsPerComponent = 8 //颜色空间每个通道占用的bit
            let bytesPerRow = width * 4 //image每一行所占用的byte
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
            if let context = CGContext(data: &(pixels), width: width, height: height, bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) {
                context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
                let pixelIndex = lrintf(Float(realPoint.y)) * width + lrintf(Float(realPoint.x))
                let newColorRgbaValue = newColor.rgbaValue
                let colorRgbaValue = pixels[pixelIndex]
                
                let clearColor = UIColor.clear
                if compareColor(color: colorRgbaValue, otherColor: clearColor.rgbaValue, tolorance: colorTolorance) {
                    return
                }

                let lineColor = UIColor.init(rgb: 0x2c1010)
                if compareColor(color: colorRgbaValue, otherColor: lineColor.rgbaValue, tolorance: colorTolorance) {
                    return
                }
                // 不能改变的颜色
                for color in unchangeableColors {
                    let colorValue = color.rgbaValue
                    if compareColor(color: colorRgbaValue, otherColor: colorValue, tolorance: colorTolorance) {
                        return
                    }
                }
                
                // 如果点击的黑色边框，直接退出
                if isBlackColor(color: colorRgbaValue) {
                    return
                }
                // 如果点击的颜色和新颜色一样，退出
                if compareColor(color: colorRgbaValue, otherColor: newColorRgbaValue, tolorance: colorTolorance) {
                    return
                }
                
                var maxX = 0
                var minX = 0
                var maxY = 0
                var minY = 0
                seedPointList.push(realPoint)
                while !seedPointList.isEmpty {

                    if let point = seedPointList.pop() {
                        let (xLeft,xRight) = fillLine(seedPoint: point, newColorRgbaValue: newColorRgbaValue,
                                                      originalColorRgbaValue: colorRgbaValue)
                        scanLine(lineNumer: Int(point.y) + 1, xLeft: xLeft, xRight: xRight, originalColorRgbaValue: colorRgbaValue)
                        scanLine(lineNumer: Int(point.y) - 1, xLeft: xLeft, xRight: xRight, originalColorRgbaValue: colorRgbaValue)
                        
                        if xLeft < minX || minX == 0 { //最小X
                            minX = xLeft
                        }
                        if xRight > maxX || maxX == 0 { //最大X
                            maxX = xRight
                        }
                        if maxY == 0 && minY == 0 {
                            maxY = Int(point.y)
                            minY = Int(point.y)
                        }
                        if maxY < Int(point.y) {
                            maxY = Int(point.y)
                        }
                        if minY > Int(point.y) {
                            minY = Int(point.y)
                        }
                    }
                }
                
                print(maxX,minX,maxY,minY)
                if isFindSeedPoint == false {
                    for  p in seedPointArray {
                        let x = p.x * widthScale
                        let y = p.y * heightScale
                        if (Int(x) < maxX && Int(x) > minX) && (Int(y) < maxY && Int(y) > minY) {
                            isFindSeedPoint = true
                            guard let index = seedPointArray.firstIndex(of: p) else { return  }
                            seedPointArray.remove(at: index)
                            break
                        }
                    }
                }

                
                if let cgImage = context.makeImage() {
                   let img = UIImage(cgImage: cgImage, scale: image?.scale ?? 2, orientation: .up)
                    let transition = CATransition.init()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction.init(name: .linear)
                    transition.type = .fade
                    layer.add(transition, forKey: "colorAnimation")
                    image = img
                    

                }
                
                if isFindSeedPoint == true && isEndCurrentFill == false {
                    isEndCurrentFill = true
                    for p in seedPointArray {
                        floodFill(from: p)
                    }
                }
                
                isFindSeedPoint = false
                isEndCurrentFill = false
            }
        }
    }
    
    /// 通过种子点向左向右填充
    ///
    /// - Parameters:
    ///   - seedPoint: 种子点
    ///   - newColorRgbaValue: 填充的新颜色的值
    ///   - originalColorRgbaValue: 触摸点颜色的值
    /// - Returns: 种子点填充的左右区间 都是闭区间
   private  func fillLine(seedPoint:CGPoint,newColorRgbaValue:UInt32,originalColorRgbaValue:UInt32) -> (Int,Int) {
        let imageW = Int(imageSize.width)
        let currntLineMinIndex = Int(seedPoint.y) * imageW
        let currntLineMaxIndex = currntLineMinIndex + imageW
        let currentPixelIndex = currntLineMinIndex + Int(seedPoint.x)
        var xleft = Int(seedPoint.x)
        var xright = xleft
        if pixels.count >= currntLineMaxIndex {
            var tmpIndex = currentPixelIndex
            while tmpIndex >=  currntLineMinIndex &&
                  compareColor(color: originalColorRgbaValue, otherColor: pixels[tmpIndex], tolorance: colorTolorance){
                pixels[tmpIndex] = newColorRgbaValue
                tmpIndex -= 1
                xleft -= 1
            }
            tmpIndex = currentPixelIndex + 1
            while tmpIndex < currntLineMaxIndex &&
                  compareColor(color: originalColorRgbaValue, otherColor: pixels[tmpIndex], tolorance: colorTolorance){
                pixels[tmpIndex] = newColorRgbaValue
                tmpIndex += 1
                xright += 1
            }
        }
        return (xleft + 1,xright)
    }
    
    
    /// 从xLeft到xRight的扫描第lineNumer行
    ///
    /// - Parameters:
    ///   - lineNumer: 行数
    ///   - xLeft: 扫描线的最左侧
    ///   - xRight: 扫描线的最右侧
    ///   - originalColorRgbaValue:  触摸点颜色的值
   private func scanLine(lineNumer:Int,xLeft:Int,xRight:Int,originalColorRgbaValue:UInt32) {
        if lineNumer < 0 || CGFloat(lineNumer) > imageSize.height - 1{
            return
        }
        var xCurrent = xLeft // 当前被扫描的点的x位置
        let currentLineOriginalIndex = lineNumer * Int(imageSize.width)
        var currentPixelIndex = currentLineOriginalIndex + xLeft // 当前被扫描的点的所在像素点的位置
        var currntLineMaxIndex = currentLineOriginalIndex + xRight // 当前扫描线需要扫描的最后一个点的位置
        var leftSpiltIndex:Int?
        if var scanLine = scanedLines[lineNumer] {
            if scanLine.xLeft >= xRight || scanLine.xRight <= xLeft {// 没有相交，什么也不做
            }else if scanLine.xLeft <= xLeft && scanLine.xRight >= xRight { // 旧扫描与新扫描的范围关系是包含
                return
            }else if scanLine.xLeft <= xLeft && scanLine.xRight <= xRight { // 旧扫描与新扫描的范围关系是左包含右被包含
                xCurrent = scanLine.xRight + 1
                currentPixelIndex = currentLineOriginalIndex + scanLine.xRight + 1
                scanLine.xRight = xRight
                scanedLines[lineNumer] = scanLine
            }else if scanLine.xLeft >= xLeft && scanLine.xRight >= xRight { // 旧扫描与新扫描的范围关系是左被包含右包含
                currntLineMaxIndex = currentLineOriginalIndex + scanLine.xLeft - 1
                leftSpiltIndex = currentLineOriginalIndex + scanLine.xLeft
                scanLine.xLeft = xLeft
                scanedLines[lineNumer] = scanLine
            }else if scanLine.xLeft >= xLeft && scanLine.xRight <= xRight { // 旧扫描与新扫描的范围关系是被包含
                scanLine.xLeft = xLeft
                scanLine.xRight = xRight
                scanedLines[lineNumer] = scanLine
            }
        }else {
            scanedLines[lineNumer] = FillLineInfo(lineNumber: lineNumer, xLeft: xLeft, xRight: xRight)
        }
        while currentPixelIndex <= currntLineMaxIndex {
            var isFindSeed = false
            //找到此区间的种子点，种子点是存在非边界且未填充的像素点，这些相邻的像素点中最右边的一个
            while currentPixelIndex < currntLineMaxIndex &&
                  compareColor(color: originalColorRgbaValue, otherColor: pixels[currentPixelIndex], tolorance: colorTolorance) {
                isFindSeed = true
                currentPixelIndex += 1
                xCurrent += 1
            }
            
            if isFindSeed {
                //如果找到种子点，需要判断while循环的退出条件是什么
                //如果是到区间最右边的倒数第二个点，则需要判断最右边的点是否和originalColorRgbaValue颜色一样，如果一样，则最右边的入栈，否则把上一个点入栈
                //如果是碰到了边界点退出的，则把当前点的上一个点入栈
                if compareColor(color: originalColorRgbaValue, otherColor: pixels[currentPixelIndex], tolorance: colorTolorance) &&
                   currentPixelIndex == currntLineMaxIndex {
                    //若当旧扫描与新扫描的范围关系是左被包含右包含，需要扫描的范围应该是新扫描范围的左点到旧扫描范围的左点的上一个点
                    //此时若扫描范围内的最右点颜色与originalColorRgbaValue一样，并且旧扫描范围的左点的颜色也与originalColorRgbaValue一样，则不需要入栈
                    if leftSpiltIndex == nil ||
                       !compareColor(color: originalColorRgbaValue, otherColor: pixels[leftSpiltIndex!], tolorance: colorTolorance){
                        seedPointList.push(CGPoint(x: xCurrent, y: lineNumer))
                    }
                }else {
                    seedPointList.push(CGPoint(x: xCurrent - 1, y: lineNumer))
                }
            }
            currentPixelIndex += 1
            xCurrent += 1
        }
    }
    
   /// 判断颜色是否是黑色
   ///
   /// - Returns: true 是 or false 不是
   private func isBlackColor(color:UInt32) -> Bool {
        let colorRed = Int((color >> 0) & 0xff)
        let colorGreen = Int((color >> 8) & 0xff)
        let colorBlue = Int((color >> 16) & 0xff)
        let colorAlpha = Int((color >> 24) & 0xff)
        
        if colorRed < colorTolorance &&
            colorGreen < colorTolorance &&
            colorBlue < colorTolorance &&
            colorAlpha > 255 - colorTolorance{
            return true
        }
        return false
    }
  
    /// 是否是相似的颜色
    ///
    /// - Returns: true 相似 or false 不相似
    private func compareColor(color:UInt32, otherColor:UInt32, tolorance:Int) -> Bool {
        if color == otherColor {
            return true
        }
        let colorRed = Int((color >> 0) & 0xff)
        let colorGreen = Int((color >> 8) & 0x00ff)
        let colorBlue = Int((color >> 16) & 0xff)
        let colorAlpha = Int((color >> 24) & 0xff)
        
        let otherColorRed = Int((otherColor >> 0) & 0xff)
        let otherColorGreen = Int((otherColor >> 8) & 0xff)
        let otherColorBlue = Int((otherColor >> 16) & 0xff)
        let otherColorAlpha = Int((otherColor >> 24) & 0xff)
        
        if abs(colorRed - otherColorRed) > tolorance ||
           abs(colorGreen - otherColorGreen) > tolorance   ||
           abs(colorBlue - otherColorBlue) > tolorance ||
           abs(colorAlpha - otherColorAlpha) > tolorance {
            return false
        }
        return true
    }
    
}


extension UIColor {
    /// 获取颜色的UInt32表示形式
    fileprivate var rgbaValue:UInt32 {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UInt32(red * 255) << 0 | UInt32(green * 255) << 8 | UInt32(blue * 255) << 16 | UInt32(alpha * 255) << 24
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
