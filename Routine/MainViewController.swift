//
//  MainViewController.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    var tableView: UITableView?
    var weekdays: Array<RoutineWeekday>? = []
    var animator: MainViewControllerAnimator = MainViewControllerAnimator()
    
    static let kMainCellId: String = "MainCell"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self._loadWeekdays()
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight) , style: UITableViewStyle.plain)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView!.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        tableView!.register(MainTableViewCell.self, forCellReuseIdentifier: MainViewController.kMainCellId)
        self.view.addSubview(tableView!)
        
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routineWeekday = weekdays![indexPath.row]
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: MainViewController.kMainCellId) as! MainTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.titleLabel?.text = routineWeekday.name
        cell.detailLabel?.text = "\(routineWeekday.routines!.count) routines"
        cell.backView?.backgroundColor = routineWeekday.blockColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("press on cell")
        var cellFrame: CGRect = tableView.rectForRow(at: indexPath)
        cellFrame.size.width  -= 30
        cellFrame.size.height -= 10
        cellFrame.origin.x = 15
        let weekdayViewController = WeekdayViewController()
        weekdayViewController.transitioningDelegate = self
        animator.startFrame = cellFrame
        DispatchQueue.main.async {
            self.present(weekdayViewController, animated: true, completion: nil)
        }
    }
    
    func _loadWeekdays() {
        weekdays?.append(RoutineWeekday(name: "Monday", blockColor: UIColor(red: 255/255, green: 225/255, blue: 210/255, alpha: 1), routines: [], bIsToday: false))
        weekdays?.append(RoutineWeekday(name: "Tuesday", blockColor: UIColor(red: 255/255, green: 245/255, blue: 210/255, alpha: 1), routines: [], bIsToday: false))
        weekdays?.append(RoutineWeekday(name: "Wednesday", blockColor: UIColor(red: 233/255, green: 255/255, blue: 210/255, alpha: 1), routines: [], bIsToday: false))
        weekdays?.append(RoutineWeekday(name: "Thursday", blockColor: UIColor(red: 210/255, green: 255/255, blue: 216/255, alpha: 1), routines: [], bIsToday: false))
        weekdays?.append(RoutineWeekday(name: "Friday", blockColor: UIColor(red: 210/255, green: 255/255, blue: 248/255, alpha: 1), routines: [], bIsToday: false))
        weekdays?.append(RoutineWeekday(name: "Saturday", blockColor: UIColor(red: 210/255, green: 232/255, blue: 255/255, alpha: 1), routines: [], bIsToday: false))
        weekdays?.append(RoutineWeekday(name: "Sunday", blockColor: UIColor(red: 214/255, green: 210/255, blue: 255/255, alpha: 1), routines: [], bIsToday: false))
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("return an animator")
        animator.animatorType = .present
        return animator
    }
}
