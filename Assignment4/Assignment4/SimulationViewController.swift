//
//  FirstViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var GridView: GridView!
    var theGrid:Grid?
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = GridView.size
        theGrid = Grid(size, size, cellInitializer: gliderInitializer)
        GridView.theGrid = theGrid
    }

    @IBAction func startGrid(_ sender: Any) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {(t:Timer) in
            self.theGrid = self.GridView.theGrid as? Grid
            self.theGrid = self.theGrid!.next()
            self.GridView.theGrid = self.theGrid
            self.GridView.setNeedsDisplay()
        }
    }
    @IBAction func nextGrid(_ sender: Any) {
        theGrid = GridView.theGrid as? Grid
        theGrid = theGrid!.next()
        GridView.theGrid = theGrid
        GridView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

