//
//  AppDelegate.swift
//  Routine
//
//  Created by mesird on 19/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // increase loading time
//        Thread.sleep(forTimeInterval: 1)
        
        // app initialization
        self._initAppData()
        
        // register local notification
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        // show main view controller
        let mainViewController = MainViewController()
        window!.rootViewController = mainViewController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        save()
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("Local notification is received!\n\(notification)")
        application.applicationIconBadgeNumber = 0
        
        let routineWeekdayId: String = notification.userInfo?["weekdayId"] as! String
        let routineId: String = notification.userInfo?["identifier"] as! String
        let routineWeekday = fetchRoutineWeekday(with: routineWeekdayId)
        let routine = fetchRoutine(withId: routineId, inRoutines: (routineWeekday?.routines)!)
        let pushAlertView = PushAlertView(routine: routine!, weekday: routineWeekday!)
        UIApplication.shared.keyWindow?.addSubview(pushAlertView)
        pushAlertView.show()
    }

    //MARK: - private methods
    
    func _initAppData() {
        
        let sharedUserDefaults: UserDefaults = UserDefaults(suiteName: appGroupId)!
        
        let secondLaunch = sharedUserDefaults.bool(forKey: userDefaultsSecondLaunch)
        if secondLaunch {
            globalRoutineWeekdays = read()
            return
        }
        var weekdays = Array<RoutineWeekday>()
        let today = weekdayForToday()
        weekdays.append(RoutineWeekday(name: "Monday",    weekday: 2, blockColor: UIColor(red: 255/255, green: 225/255, blue: 210/255, alpha: 1), routines: [], bIsToday: Bool(today == 2)))
        weekdays.append(RoutineWeekday(name: "Tuesday",   weekday: 3, blockColor: UIColor(red: 255/255, green: 245/255, blue: 210/255, alpha: 1), routines: [], bIsToday: Bool(today == 3)))
        weekdays.append(RoutineWeekday(name: "Wednesday", weekday: 4, blockColor: UIColor(red: 233/255, green: 255/255, blue: 210/255, alpha: 1), routines: [], bIsToday: Bool(today == 4)))
        weekdays.append(RoutineWeekday(name: "Thursday",  weekday: 5, blockColor: UIColor(red: 210/255, green: 255/255, blue: 216/255, alpha: 1), routines: [], bIsToday: Bool(today == 5)))
        weekdays.append(RoutineWeekday(name: "Friday",    weekday: 6, blockColor: UIColor(red: 210/255, green: 255/255, blue: 248/255, alpha: 1), routines: [], bIsToday: Bool(today == 6)))
        weekdays.append(RoutineWeekday(name: "Saturday",  weekday: 7, blockColor: UIColor(red: 210/255, green: 232/255, blue: 255/255, alpha: 1), routines: [], bIsToday: Bool(today == 7)))
        weekdays.append(RoutineWeekday(name: "Sunday",    weekday: 1, blockColor: UIColor(red: 214/255, green: 210/255, blue: 255/255, alpha: 1), routines: [], bIsToday: Bool(today == 1)))
        globalRoutineWeekdays = weekdays
        sharedUserDefaults.set(true, forKey: userDefaultsSecondLaunch)
        save()
    }
    
}

