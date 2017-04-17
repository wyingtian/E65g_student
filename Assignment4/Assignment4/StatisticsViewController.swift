//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Ying on 3/29/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//


import UIKit

class StatisticsViewController: UIViewController, EngineDelegate {
    @IBOutlet weak var numLivingCell: UILabel!
    
    @IBOutlet weak var numBornCell: UILabel!
    
    @IBOutlet weak var numDiedCell: UILabel!
    
    @IBOutlet weak var numEmptyCell: UILabel!
    
    @IBOutlet var statisticView: UIView!
    
    
    var engine:StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the singleton engine from standardEngine class
        engine = StandardEngine.engine
        engine.delegate = self
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                var countArray = self.engine.countCellState()
                self.numLivingCell.text = "Living:  " + countArray[0]
                self.numBornCell.text = "Born:  " + countArray[1]
                self.numDiedCell.text = "Died:  " + countArray[2]
                self.numEmptyCell.text = "Empty:  " + countArray[3]
                self.statisticView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // implementation of EngineDelegate protoco
    func engineDidUpdate(withGrid: GridProtocol){
        var countArray = self.engine.countCellState()
        self.numLivingCell.text = countArray[0]
        self.numBornCell.text = countArray[1]
        self.numDiedCell.text = countArray[2]
        self.numEmptyCell.text = countArray[3]
        self.statisticView.setNeedsDisplay()
    }
}
