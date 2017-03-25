//
//  WeekdayViewController.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class WeekdayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeekdayColorProtocol, UIViewControllerTransitioningDelegate {
    
    var backView: UIView?
    var tableView: UITableView?
    var doneButton: UIButton?
    var cancelButton: UIButton?
    var blurView: UIVisualEffectView?
    var colorSelectView: WeekdayColorSelectView?
    
    var routineWeekday: RoutineWeekday?
    
    var animator: MainViewControllerAnimator = MainViewControllerAnimator()
    
    let kWeekdayTextCellId = "WeekdayTextCell"
    let kWeekdayColorCellId = "WeekdayColorCell"
    let kWeekdaySelectCellId = "WeekdaySelectCell"
    let kWeekdayRoutineCellId = "WeekdayRoutineCell"
    let kWeekdayAddOneCellId = "WeekdayAddOneCell"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        backView = UIView(frame: UIScreen.main.bounds)
        backView!.alpha = 0
        self.view.addSubview(backView!)
        
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
        
        tableView = UITableView(frame: CGRect(x: 0, y: 80, width: screenWidth, height: screenHeight - 80) , style: .plain)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.separatorColor = color(with: 231, green: 231, blue: 231)
        tableView!.backgroundColor = UIColor.white
        tableView!.keyboardDismissMode = .onDrag
        tableView!.tableFooterView = UIView()
        tableView!.register(WeekdayTextTableViewCell.self, forCellReuseIdentifier: kWeekdayTextCellId)
        tableView!.register(WeekdayColorTableViewCell.self, forCellReuseIdentifier: kWeekdayColorCellId)
        tableView!.register(WeekdaySelectTableViewCell.self, forCellReuseIdentifier: kWeekdaySelectCellId)
        tableView!.register(WeekdayRoutineTableViewCell.self, forCellReuseIdentifier: kWeekdayRoutineCellId)
        tableView!.register(WeekdayAddOneTableViewCell.self, forCellReuseIdentifier: kWeekdayAddOneCellId)
        backView!.addSubview(tableView!)
        
        blurView = UIVisualEffectView(frame: UIScreen.main.bounds)
        blurView!.effect = UIBlurEffect(style: .dark)
        blurView!.alpha = 0
        backView!.addSubview(blurView!)
        
        colorSelectView = WeekdayColorSelectView(frame: UIScreen.main.bounds)
        colorSelectView!.delegate = self
        colorSelectView!.isHidden = true
        backView?.addSubview(colorSelectView!)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            if routineWeekday != nil {
                return routineWeekday!.routines!.count + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell: WeekdayTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: kWeekdayTextCellId) as! WeekdayTextTableViewCell
                cell.selectionStyle = .none
                cell.titleLabel?.text = "Routine Name"
                cell.textField?.placeholder = "Input name here"
                cell.textField?.text = routineWeekday?.name
                let line = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: onePixel))
                line.backgroundColor = color(with: 231, green: 231, blue: 231)
                cell.addSubview(line)
                return cell
            } else if indexPath.row == 1 {
                let cell: WeekdayColorTableViewCell = tableView.dequeueReusableCell(withIdentifier: kWeekdayColorCellId) as! WeekdayColorTableViewCell
                cell.selectionStyle = .none
                cell.titleLabel?.text = "Block Color"
                cell.colorView?.backgroundColor = routineWeekday?.blockColor ?? UIColor.lightGray
                return cell
            } else if indexPath.row == 2 {
                let cell: WeekdaySelectTableViewCell = tableView.dequeueReusableCell(withIdentifier: kWeekdaySelectCellId) as! WeekdaySelectTableViewCell
                cell.selectionStyle = .none
                cell.titleLabel?.text = "Need Notification"
                if routineWeekday?.blockColor != nil {
                    cell.switcher?.onTintColor = routineWeekday?.blockColor
                }
                let line = UIView(frame: CGRect(x: 0, y: 50 - onePixel, width: screenWidth, height: onePixel))
                line.backgroundColor = color(with: 231, green: 231, blue: 231)
                cell.addSubview(line)
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == routineWeekday?.routines!.count {
                let cell: WeekdayAddOneTableViewCell = tableView.dequeueReusableCell(withIdentifier: kWeekdayAddOneCellId) as! WeekdayAddOneTableViewCell
                cell.selectionStyle = .none
                return cell
            } else {
                let cell: WeekdayRoutineTableViewCell = tableView.dequeueReusableCell(withIdentifier: kWeekdayRoutineCellId) as! WeekdayRoutineTableViewCell
                cell.selectionStyle = .none
                cell.bellView?.isHidden = false
                cell.titleLabel?.text = "Wash in the morning"
                cell.timeLabel?.text = "8:30 - 9:00"
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        header.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 20, width: screenWidth - 30, height: 30))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
        if section == 0 {
            titleLabel.text = "Basics"
        } else {
            titleLabel.text = "Routines"
        }
        header.addSubview(titleLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: screenWidth, bottom: 0, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                // tap on 'block color'
                colorSelectView!._display()
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.blurView!.alpha = 0.5
                    })
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == routineWeekday?.routines?.count {
                // tap on 'add new routine'
                let routineViewController = RoutineEditViewController()
                routineViewController.routineEditType = .add
                routineViewController.transitioningDelegate = self
                self.present(routineViewController, animated: true, completion: nil)
            }
        }
    }
    
    func didSelect(color: UIColor) {
        routineWeekday?.blockColor = color
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView!.alpha = 0
            })
        }
        tableView!.reloadData()
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.animatorType = .present
        return animator
    }
}
