//
//  RoutineEditViewController.swift
//  Routine
//
//  Created by mesird on 20/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

enum DatePickType {
    case start, end
}

enum RoutineEditType {
    case add, edit
}

protocol RoutineEditProtocol {
    
    func didCreateRoutine(routine: Routine)
    func didModifyRoutine(routine: Routine)
    func didDeleteRoutine(routine: Routine)
}

class RoutineEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var tableView: UITableView?
    var routineNameField: UITextField?
    var doneButton: UIButton?
    var cancelButton: UIButton?
    var titleLabel: UILabel?
    var backView: UIView?
    var datePicker: UIDatePicker?
    var datePickerBackView: UIView?
    
    // routine
    var routine: Routine?
    // weekday id
    var routineWeekdayId: String?
    // routine edit protocol delegate
    var delegate: RoutineEditProtocol?
    // switcher color
    var switcherColor: UIColor?
    // edit type
    var routineEditType: RoutineEditType?
    // pick type
    var datePickType: DatePickType = .start
    
    let kRoutineTextCellId   = "RoutineTextCell"
    let kRoutineTimeCellId   = "RoutineTimeCell"
    let kRoutineSelectCellId = "RoutineSelectCell"
    let kRoutineDeleteCellId = "RoutineDeleteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        backView = UIView(frame: UIScreen.main.bounds)
        backView!.alpha = 0
        self.view.addSubview(backView!)
        
        titleLabel = UILabel(frame: CGRect(x: 15, y: 20, width: screenWidth - 30, height: 45))
        titleLabel!.textColor = color(with: 98, green: 98, blue: 98)
        titleLabel!.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)
        titleLabel!.textAlignment = .center
        titleLabel!.text = "Routine"
        backView!.addSubview(titleLabel!)
        
        doneButton = UIButton(frame: CGRect(x: screenWidth - 80, y: 30, width: 80, height: 30))
        doneButton!.setTitle("Done", for: .normal)
        doneButton!.setTitleColor(UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1), for: .normal)
        doneButton!.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        doneButton!.addTarget(self, action: #selector(self._pressOnDoneButton), for: .touchUpInside)
        backView!.addSubview(doneButton!)
        
        cancelButton = UIButton(frame: CGRect(x: 0, y: 30, width: 80, height: 30))
        cancelButton!.setTitle("Cancel", for: .normal)
        cancelButton!.setTitleColor(UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1), for: .normal)
        cancelButton!.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        cancelButton!.addTarget(self, action: #selector(self._pressOnCancelButton), for: .touchUpInside)
        backView!.addSubview(cancelButton!)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 80, width: screenWidth, height: screenHeight - 80) , style: .grouped)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.separatorColor = color(with: 231, green: 231, blue: 231)
        tableView!.backgroundColor = UIColor.white
        tableView!.keyboardDismissMode = .onDrag
        tableView!.register(RoutineTextTableViewCell.self, forCellReuseIdentifier: kRoutineTextCellId)
        tableView!.register(RoutineTimeTableViewCell.self, forCellReuseIdentifier: kRoutineTimeCellId)
        tableView!.register(RoutineSelectTableViewCell.self, forCellReuseIdentifier: kRoutineSelectCellId)
        tableView!.register(RoutineDeleteTableViewCell.self, forCellReuseIdentifier: kRoutineDeleteCellId)
        tableView!.tableFooterView = UIView(frame: CGRect.zero)
        backView!.addSubview(tableView!)
        
        if routine == nil {
            let now = Date()
            routine = Routine(name: "", start: now, end: now, needNotification: false)
        }
        
        if routineEditType == .add {
            title = "Add routine"
        } else {
            title = "Edit routine"
        }
        
        datePickerBackView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        datePickerBackView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        datePickerBackView?.isHidden = true
        self.datePickerBackView?.alpha = 0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self._pressOndatePickerBackView))
        datePickerBackView?.addGestureRecognizer(tapRecognizer)
        backView!.addSubview(datePickerBackView!)
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 200))
        datePicker?.backgroundColor = UIColor.white
        datePicker?.datePickerMode = UIDatePickerMode.time
        datePicker?.addTarget(self, action: #selector(self._datePickerValueChanged), for: UIControlEvents.valueChanged)
        backView!.addSubview(datePicker!)
        
        tableView!.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.backView!.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func _pressOnCancelButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func _pressOnDoneButton(sender: UIButton) {
        
        if routineNameField?.text?.characters.count == 0 {
            ToastView(title: "Please enter routine name").show(inSeconds: 1.5)
            return
        }
        
        if (routine?.start)! > (routine?.end)! {
            ToastView(title: "Start time larger than end time").show(inSeconds: 1.5)
            return
        }
        
        routine!.name = (routineNameField?.text)!
        
        if delegate != nil {
            if routineEditType == .add {
                delegate!.didCreateRoutine(routine: routine!)
            } else {
                delegate!.didModifyRoutine(routine: routine!)
            }
        }
        
        // back to previous view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - table view delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return routineEditType == .add ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: RoutineTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: kRoutineTextCellId) as! RoutineTextTableViewCell
            cell.selectionStyle = .none
            let nameField = cell.textField
            nameField?.text = routine?.name
            nameField?.placeholder = "Input routine name here"
            nameField?.delegate = self
            routineNameField = nameField
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                let cell: RoutineTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: kRoutineTimeCellId) as! RoutineTimeTableViewCell
                cell.titleLabel?.text = "Start Time"
                cell.detailLabel?.text = dateFormatter.string(from: routine!.start)
                return cell
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                let cell: RoutineTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: kRoutineTimeCellId) as! RoutineTimeTableViewCell
                cell.titleLabel?.text = "End Time"
                cell.detailLabel?.text = dateFormatter.string(from: routine!.end)
                return cell
            }
        } else if indexPath.section == 2 {
            let cell: RoutineSelectTableViewCell = tableView.dequeueReusableCell(withIdentifier: kRoutineSelectCellId) as! RoutineSelectTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel?.text = "Need Notification"
            cell.switcher?.isOn = routine!.needNotification
            if switcherColor != nil {
                cell.switcher?.onTintColor = switcherColor!
            }
            cell.switcher?.addTarget(self, action: #selector(self._pressOnSwitch), for: UIControlEvents.touchUpInside)
            return cell
        } else if indexPath.section == 3 {
            let cell: RoutineDeleteTableViewCell = tableView.dequeueReusableCell(withIdentifier: kRoutineDeleteCellId) as! RoutineDeleteTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 3 {
            return 30
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return self._headerView(with: "Routine name")
        } else if section == 1 {
            return self._headerView(with: "Time duration")
        } else if section == 2 {
            return self._headerView(with: "Additional")
        }
        return UIView()
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
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                // delete
                let alertController = UIAlertController(title: "Warning", message: "Are you sure to delete this routine?", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
                    // delete routine and pop
                    if self.delegate != nil {
                        self.delegate!.didDeleteRoutine(routine: self.routine!)
                    }
                    self.dismiss(animated: true, completion: nil)
                })
                let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = color(with: 175, green: 175, blue: 175)
        view.addSubview(titleLabel)
        return view
    }
    
    func _showDatePicker(with type: DatePickType) {
        self.datePickType = type
        
        self.datePickerBackView?.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.datePicker?.frame = CGRect(x: 0, y: screenHeight - 200, width: screenWidth, height: 200)
            self.datePickerBackView?.alpha = 1
        })
    }
    
    func _datePickerValueChanged(sender: UIDatePicker) {
        switch self.datePickType {
        case .start:
            routine!.start = sender.date
        case .end:
            routine!.end = sender.date
        }
        tableView!.reloadData()
    }
    
    func _pressOndatePickerBackView(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.datePicker?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 200)
            self.datePickerBackView?.alpha = 0
        }) { (finished: Bool) in
            if finished {
                self.datePickerBackView?.isHidden = true
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
