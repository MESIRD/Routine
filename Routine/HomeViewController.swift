//
//  HomeViewController.swift
//  Routine
//
//  Created by mesird on 20/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var routines: Array<Routine> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self._loadRoutines()
        NotificationCenter.default.addObserver(self, selector: #selector(self._loadRoutines), name: NSNotification.Name(rawValue: notificationRoutineCreated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._loadRoutines), name: NSNotification.Name(rawValue: notificationRoutineModified), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - table view delegate
    
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
        let routine = routines[indexPath.row]
        let routineEditViewController: RoutineEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "RoutineEditViewController") as! RoutineEditViewController
        routineEditViewController.routineEditType = .edit
        routineEditViewController.routine = routine
        self.navigationController?.pushViewController(routineEditViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction: UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (rowAction, indexPath) in
            let routine: Routine = self.routines[indexPath.row]
            removeLocalNotification(routine: routine)
            self.routines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            saveRoutines(routines: self.routines)
        }
        return [deleteAction]
    }
    
    //MARK: - private methods
    
    func _loadRoutines() {
        routines = readRoutines()
        tableView.reloadData()
    }
    
    func _buildDateText(start: Date, end: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
    }

}
