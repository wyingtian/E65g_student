
//  Created by Ying on 4/24/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, EngineDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    // size input text field
    @IBOutlet weak var sizeInput: UITextField!
    // stepper followed by size input
    @IBOutlet weak var sizeStepper: UIStepper!
    // frequecy control slider
    @IBOutlet weak var Slider2: UISlider!
    // the switch control grid to be on and off
    @IBOutlet weak var mySwitch: UISwitch!
    // an array has all the title name of json data
    var tableData:[String] = []
    //var gridStateData:[[[Int]]] = []
    // a diciontary pased from json data, key is the title name, value is an array of cell positions(pos are array of Int)
    var gridStateDataDict:[String: [[Int]]] = [:]
    var engine: StandardEngine!
    
    override func viewDidLoad() {
        
        // make the slider vertical
        Slider2.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2))
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // get the singleton engine from standardEngine class
        engine = StandardEngine.engine
    
        // set delegate to recieve notification from standard engine
        engine.delegate = self
        
        // default swith state is off
        mySwitch.setOn(false, animated: true)
        
        get_data_from_url("https://dl.dropboxusercontent.com/u/7544475/S65g.json")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = tableData[indexPath.item]
        return cell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    //   support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // change the backbutton text from "back" to "Cancel"
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
        
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            let titleName = tableData[indexPath.row]
            let gridStateData = gridStateDataDict[titleName]
            if let vc = segue.destination as? GridEditorViewController {
                vc.titleName = titleName
                vc.gridStateData = gridStateData
            }
        }
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

    func get_data_from_url(_ link:String) {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("Failed to get json")
                return
            }
            self.extract_json(data!)
        })
        task.resume()
    }
    
    
    func extract_json(_ data: Data){
        let json: Any?
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch {
            return
        }
        
        guard let data_list = json as? NSArray else {
            return
        }
        
        if let shape_list = json as? NSArray{
            for i in 0 ..< data_list.count{
                if let shape_obj = shape_list[i] as? NSDictionary{
                    if let title = shape_obj["title"] as? String , let gridState = shape_obj["contents"] as? [[Int]]{
                        gridStateDataDict[title] = gridState
                        tableData.append(title)
                    }
                }
            }
        }
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
    }

}

