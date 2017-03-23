//
//  FirstViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var GridView: GridView!
    
    @IBAction func nextGrid(_ sender: Any) {
       GridView.setGrid(theGrid.next())
        GridView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

