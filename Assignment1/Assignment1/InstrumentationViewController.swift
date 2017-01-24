//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var Section1: UIView!
    @IBOutlet weak var Section2: UIView!
    @IBOutlet weak var Slider1: UISlider!
    @IBOutlet weak var Slider2: UISlider!
    override func viewDidLoad() {
        Section1.layer.cornerRadius = 10
        Section2.layer.cornerRadius = 10
        Slider1.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2))
        Slider2.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2))
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

