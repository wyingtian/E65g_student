//
//  GridEditorViewController.swift
//  Conway
//
//  Created by Ying on 4/24/17.
//  Copyright © 2017 edu.harvard.conway. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    var titleName:String?
    var gridStateData:[[Int]]?
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var gridView: GridView!
    var engine:StandardEngine!
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the singleton engine from standardEngine class
        engine = StandardEngine.engine
        
        // set the griddatasource of the gridview to be this griddatasource
        gridView.theGrid = self
        
        // set delegate to recieve notification from standard engine
        engine.delegate = self
        
        gridView.size = engine.theGrid.getGridSize()
        
        label.text = titleName
        
        loadGridStateData()
    }

    func loadGridStateData() {
        for i in 0..<self.gridView.size {
            for j in 0..<self.gridView.size {
                engine.theGrid[(i, j)] = CellState.empty
            }
        }
        for pos in gridStateData! {
            engine.theGrid[(pos[0], pos[1])] = CellState.born
        }

        self.gridView.setNeedsDisplay()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
