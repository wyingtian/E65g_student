//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, EngineDelegate {
    // size input text field
    @IBOutlet weak var sizeInput: UITextField!
    // stepper followed by size input
    @IBOutlet weak var sizeStepper: UIStepper!
    // frequecy control slider
    @IBOutlet weak var Slider2: UISlider!
    // the switch control grid to be on and off
    @IBOutlet weak var mySwitch: UISwitch!

    var engine: StandardEngine!
    override func viewDidLoad() {

        // make the slider vertical
        Slider2.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2))
        super.viewDidLoad()
        
        // get the singleton engine from standardEngine class
        engine = StandardEngine.engine
    
        // set delegate to recieve notification from standard engine
        engine.delegate = self
        
        // default swith state is off
        mySwitch.setOn(false, animated: true)
    }
    @IBAction func setSize(_ sender: UITextField) {
        if Int(sender.text!) != nil {
            //engine.theGrid = Grid(Int(sender.text!)!, Int(sender.text!)!)
            sizeStepper.value = Double(sizeInput.text!)!
        }
        let nb = NotificationCenter.default
        let nameb = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: nameb,
                             object: nil,
                             userInfo: ["engine" : self])
        nb.post(n)
    }

    // Stepper to change the size of grid
    // inital value is 20
    // use notification center to update the gridview
    @IBAction func sizeStepper(_ sender: UIStepper) {
        sizeInput.text = String(Int(sender.value))
        engine.theGrid = Grid(Int(sender.value), Int(sender.value))
        let nb = NotificationCenter.default
        let nameb = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: nameb,
                             object: nil,
                             userInfo: ["engine" : self])
        nb.post(n)
    }
    
    
    // switch on and off to control the grid
    @IBAction func timerSwitch(_ sender: Any) {
        if mySwitch.isOn {
            if engine.timer != nil{
                engine.timer!.invalidate()
                engine.timer = nil
            }
            engine.timerInterval = TimeInterval(Slider2.value)
        }else{
            engine.timerInterval = 0.0
        }
    }
    
    //frequency values from 0.1 to 10hz
    @IBAction func freqSlider(_ sender: Any) {
        if mySwitch.isOn {
            if engine.timer != nil{
                engine.timer!.invalidate()
                engine.timer = nil
            }
            engine.timerInterval = TimeInterval(Slider2.value)
        }
    }
    // implementation of EngineDelegate protocol
    func engineDidUpdate(withGrid: GridProtocol){
    }
    // implementation of GridViewDataSource protocol
    public subscript (pos: Position) -> CellState {
        get {  return engine.theGrid[pos] }
        set {  engine.theGrid[pos] = newValue }
    }

}

