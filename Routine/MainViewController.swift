//
//  MainViewController.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    var tableView: MainTableView?
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
        let tableHeaderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120))
        tableHeaderLabel.textColor = UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)
        tableHeaderLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)
        tableHeaderLabel.text = "Weekdays"
        tableHeaderLabel.textAlignment = .center
        
        tableView = MainTableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight) , style: UITableViewStyle.plain)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView!.tableHeaderView = tableHeaderLabel
        tableView!.register(MainTableViewCell.self, forCellReuseIdentifier: MainViewController.kMainCellId)
        self.view.addSubview(tableView!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self._refreshWeekdays), name: NSNotification.Name(rawValue: notificationWeekdaySaved), object: nil)
        
        self._loadWeekdays()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View Delegate
    
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
        cell.bellView?.isHidden = !routineWeekday.bNeedNotification!
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellFrame: CGRect = tableView.rectForRow(at: indexPath)
        cellFrame.size.width  -= 30
        cellFrame.size.height -= 10
        cellFrame.origin.x = 15
        let weekdayViewController = WeekdayViewController()
        weekdayViewController.transitioningDelegate = self
        weekdayViewController.routineWeekday = weekdays![indexPath.row]
        animator.startFrame = cellFrame
        DispatchQueue.main.async {
            self.present(weekdayViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Private Method
    
    func _loadWeekdays() {
        weekdays = globalRoutineWeekdays
        tableView!.reloadData()
    }
    
    func _refreshWeekdays() {
        self._loadWeekdays()
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.animatorType = .present
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.animatorType = .dismiss
        return animator
    }
}
