//
//  FirstViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    @IBOutlet weak var gridView: GridView!
    var engine:StandardEngine!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the singleton engine from standardEngine class
        engine = StandardEngine.engine
        
        // set the griddatasource of the gridview to be this griddatasource
        gridView.theGrid = self
        
        // set delegate to recieve notification from standard engine
        engine.delegate = self
        
        gridView.size = engine.theGrid.getGridSize()
       
        // add observer to get notification from standard engine
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.gridView.size = self.engine.theGrid.getGridSize()
                self.gridView.setNeedsDisplay()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        for i in 0..<self.gridView.size {
            for j in 0..<self.gridView.size {
                engine.theGrid[(i, j)] = CellState.empty
            }
        }
        self.gridView.setNeedsDisplay()
        // Whenever the grid is created or changed publish the grid object using an NSNotification.
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nc.post(n)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    
    @IBAction func sizeStepper(_ sender: UIStepper) {
        engine.theGrid = Grid(Int(sender.value), Int(sender.value))
        gridView.size = engine.theGrid.getGridSize()
    }
   
    
   // push step button to make the grid to change at 1second per state
    @IBAction func nextGrid(_ sender: Any) {
        engine.step()
        gridView.setNeedsDisplay()
    }

    
    // implementation of EngineDelegate protocol
    func engineDidUpdate(withGrid: GridProtocol){
        self.gridView.setNeedsDisplay()
    }
    
    // implementation of GridViewDataSource protocol
    public subscript (pos: Position) -> CellState {
        get {  return engine.theGrid[pos] }
        set {  engine.theGrid[pos] = newValue }
    }
    public func getGridSize() -> Int{
        return engine.theGrid.getGridSize()
    }
}

