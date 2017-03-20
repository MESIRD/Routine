//
//  RoutineEditViewController.swift
//  Routine
//
//  Created by mesird on 20/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit
import RoutineEntity

enum DatePickType {
    case start, end
}

enum RoutineEditType {
    case add, edit
}

class RoutineEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    public var routine: Routine?
    
    var routineNameField: UITextField?
    
    var datePicker: UIDatePicker?
    var backView: UIView?
    
    public var routineEditType: RoutineEditType?
    var datePickType: DatePickType = .start
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if routine == nil {
            let now = Date()
            routine = Routine(name: "", start: now, end: now, needNotification: false)
        }
        
        if routineEditType == .add {
            title = "Add routine"
        } else {
            title = "Edit routine"
        }
        
        backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        backView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backView?.isHidden = true
        self.backView?.alpha = 0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self._pressOnBackView))
        backView?.addGestureRecognizer(tapRecognizer)
        self.view.addSubview(backView!)
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 200))
        datePicker?.backgroundColor = UIColor.white
        datePicker?.datePickerMode = UIDatePickerMode.time
        datePicker?.addTarget(self, action: #selector(self._datePickerValueChanged), for: UIControlEvents.valueChanged)
        self.view.addSubview(datePicker!)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func _pressOnDoneItem(_ sender: UIBarButtonItem) {
        if routineNameField?.text?.characters.count == 0 {
            return
        }
        routine!.name = (routineNameField?.text)!
        
        var routines: Array<Routine>? = readRoutines()
        if routines != nil {
            var contains: Bool = false
            for index in 0..<routines!.count {
                if routines![index].id == routine?.id {
                    contains = true
                    routines![index] = routine!
                    break
                }
            }
            if !contains {
                routines!.append(routine!)
            }
        } else {
            routines = []
            routines!.append(routine!)
        }
        saveRoutines(routines: routines!)
        
        // schedule local notification
        if routine!.needNotification {
            scheduleLocalNotification(routine: routine!)
        } else {
            removeLocalNotification(routine: routine!)
        }
        
        // post created notification
        if routineEditType == .add {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationRoutineCreated), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationRoutineModified), object: nil)
        }
        
        // back to previous view controller
        navigationController!.popViewController(animated: true)
    }
    
    //MARK: - table view delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddInputCell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            let nameField = cell?.viewWithTag(101) as! UITextField
            nameField.text = routine?.name
            nameField.delegate = self
            routineNameField = nameField
            return cell!
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDateCell")
                cell?.textLabel?.text = "Start Time"
                cell?.detailTextLabel?.text = dateFormatter.string(from: routine!.start)
                return cell!
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDateCell")
                cell?.textLabel?.text = "End Time"
                cell?.detailTextLabel?.text = dateFormatter.string(from: routine!.end)
                return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSelectCell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.textLabel?.text = "Need Notification"
            let switcher = UISwitch(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
            switcher.isOn = routine!.needNotification
            switcher.addTarget(self, action: #selector(self._pressOnSwitch), for: UIControlEvents.touchUpInside)
            cell?.accessoryView = switcher
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self._headerView(with: "Routine name")
        } else if section == 1 {
            return self._headerView(with: "Time duration")
        } else {
            return self._headerView(with: "Additional")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        routineNameField?.endEditing(true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // start
                self._showDatePicker(with: .start)
            } else {
                // end
                self._showDatePicker(with: .end)
            }
        }
    }
    
    //MARK: - text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fieldText = textField.text as NSString?
        let newText = fieldText?.replacingCharacters(in: range, with: string)
        routine?.name = newText!
        return true
    }
    
    func _headerView(with title: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        view.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 20, width: screenWidth - 15, height: 30))
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.lightGray
        view.addSubview(titleLabel)
        return view
    }
    
    func _showDatePicker(with type: DatePickType) {
        self.datePickType = type
        
        self.backView?.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.datePicker?.frame = CGRect(x: 0, y: screenHeight - 200, width: screenWidth, height: 200)
            self.backView?.alpha = 1
        })
    }
    
    func _datePickerValueChanged(sender: UIDatePicker) {
        switch self.datePickType {
        case .start:
            routine!.start = sender.date
        case .end:
            routine!.end = sender.date
        }
        tableView.reloadData()
    }
    
    func _pressOnBackView(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.datePicker?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 200)
            self.backView?.alpha = 0
        }) { (finished: Bool) in
            if finished {
                self.backView?.isHidden = true
            }
        }
    }
    
    func _pressOnSwitch(sender: UISwitch) {
        if sender.isOn {
            routine!.needNotification = true
        } else {
            routine!.needNotification = false
        }
    }
}
