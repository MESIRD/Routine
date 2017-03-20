//
//  ViewController.swift
//  Routine
//
//  Created by mesird on 19/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit
import RoutineModel

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var routines: Array<Routine> = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self._loadRoutines()
        NotificationCenter.default.addObserver(self, selector: #selector(self._loadRoutines), name: NSNotification.Name(rawValue: notificationRoutineCreated), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routine = routines[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell")
        cell?.textLabel?.text = routine.name
        cell?.detailTextLabel?.text = self._buildDateText(start: routine.start, end: routine.end)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func _loadRoutines() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        routines = readRoutines()
        
//        routines .append(Routine(name: "Sleep", start: dateFormatter.date(from: "22:00")!, end: dateFormatter.date(from: "08:00")!, needNotification: true))
//        routines .append(Routine(name: "Washes", start: dateFormatter.date(from: "08:00")!, end: dateFormatter.date(from: "08:30")!, needNotification: true))
//        routines .append(Routine(name: "Go to work", start: dateFormatter.date(from: "08:30")!, end: dateFormatter.date(from: "09:00")!, needNotification: true))
//        routines .append(Routine(name: "Morning work", start: dateFormatter.date(from: "09:00")!, end: dateFormatter.date(from: "12:00")!, needNotification: true))
//        routines .append(Routine(name: "Lunch", start: dateFormatter.date(from: "12:00")!, end: dateFormatter.date(from: "13:30")!, needNotification: true))
//        routines .append(Routine(name: "Afternoon work", start: dateFormatter.date(from: "13:30")!, end: dateFormatter.date(from: "18:00")!, needNotification: true))
//        routines .append(Routine(name: "Go home", start: dateFormatter.date(from: "18:00")!, end: dateFormatter.date(from: "18:30")!, needNotification: true))
//        routines .append(Routine(name: "Study", start: dateFormatter.date(from: "18:30")!, end: dateFormatter.date(from: "22:00")!, needNotification: true))
        tableView.reloadData()
    }
    
    func _buildDateText(start: Date, end: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
    }
}

