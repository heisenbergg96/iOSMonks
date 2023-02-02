import Foundation

public struct Point {
    
    let x: Double
    let y: Double
}

var shouldDrawLine = true

public func printValues(_ dc: Point, width: Double = 10, height: Double = 10) {
    
    let halfWidth = width / 2
    let halfHeight = height / 2
    
    if( dc.x < halfWidth) {
        
        let x = dc.x
        let y = dc.y - halfHeight * floor(dc.y/halfHeight)
        
        let value = Point(x: x * 2.0, y: y * 2.0)
        print("Input = \(dc)", "Output = \(value)")
        
    } else {
        if shouldDrawLine {
            print("\n \n ====================================================================== \n \n")
            shouldDrawLine = false
        }
        let x = dc.x - halfWidth * floor(dc.x/halfWidth)
        let y = dc.y - halfHeight * floor(dc.y/halfHeight)
        let value = Point(x: x * 2.0, y: y * 2.0)
        print("Input = \(dc)", "Output = \(value)")
    }
}
