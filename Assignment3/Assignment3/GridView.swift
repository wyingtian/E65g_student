//
//  GridView.swift
//  Assignment3
//
//  Created by Ying on 3/21/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
    @IBInspectable var size:Int = 15
    
    @IBInspectable var livingColor : UIColor = UIColor.green
    @IBInspectable var emptyColor : UIColor = UIColor.darkGray
    @IBInspectable var bornColor : UIColor = UIColor(red:0.0, green:1.0, blue:0.0, alpha:0.6)
    @IBInspectable var diedColor : UIColor = UIColor(white:0.333,alpha:0.6)
    @IBInspectable var gridColor : UIColor = UIColor.black
    @IBInspectable var gridWith: CGFloat = 0.1
 
    
    func setGrid(_ newGrid:Grid){
        theGrid = newGrid
    }
    func getSize() -> Int{
        return size
    }
    override func draw(_ rect: CGRect) {
        let size = CGSize(
            width: rect.size.width / CGFloat(self.size),
            height: rect.size.height / CGFloat(self.size)
        )
       
        let base = rect.origin
        (0 ... self.size).forEach { i in
            (0 ..< self.size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * size.width),
                    y: base.y + (CGFloat(j) * size.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: size
                )
                let p = Position(i,j)
                switch theGrid[p].description() {
                    
                case "born" :
                    let path = UIBezierPath(ovalIn: subRect)
                    bornColor.setFill()
                    path.fill()
                    
                case "empty" :
                    let path = UIBezierPath(ovalIn: subRect)
                    emptyColor.setFill()
                    path.fill()
                   
                case "alive" :
                    let path = UIBezierPath(ovalIn: subRect)
                    livingColor.setFill()
                    path.fill()
                   
                case "died" :
                    let path = UIBezierPath(ovalIn: subRect)
                    diedColor.setFill()
                    path.fill()
                default: break
                }
            }
        }
        
        //create the path
        (0 ... self.size).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(self.size) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(self.size) * rect.size.height)
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = gridWith
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let xPos = floor( touch.location(in:self).x / (self.bounds.size.width / CGFloat(self.size)))
            
            let yPos = floor( touch.location(in:self).y / (self.bounds.size.height / CGFloat(self.size)))
            
            let p = (Int(xPos),Int(yPos))
            theGrid[p] = theGrid[p].toggle(theGrid[p])
            setNeedsDisplay()
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
}
