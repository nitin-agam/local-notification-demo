//
//  NotificationListController.swift
//  CollectionGridViewDemo
//
//  Created by Nitin A on 30/10/18.
//  Copyright © 2018 Nitin Aggarwal. All rights reserved.
//

import UIKit

class NotificationListController: UITableViewController {

    private var sectionTitles: [String] = []
    private var dataArray: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        navigationItem.title = "Notifications"
        tableView.backgroundColor = .yellow
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        sectionTitles = ["Default", "Attachment", "Actions", "Custom UI"]
        dataArray = [["Time interval trigger", "Calendar trigger", "Location trigger"],
            ["Image", "GIF image", "Audio", "Video"],
            ["Category 1", "Category 2", "Category 3"],
            ["Custom UI with Media Player"]]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Make sure, I'm using time interval = 3 seconds to fire notification after select a row.
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0: // Default notifications
            switch indexPath.row {
                case 0: NotificationManager.shared.addNotificationWithTimeInterval()
                case 1: NotificationManager.shared.addNotificationWithCalendar()
                case 2: NotificationManager.shared.addNotificationWithLocation()
                default: break
            }
            
        case 1: // Attachment notifications
            switch indexPath.row {
            case 0: NotificationManager.shared.addNotificationWithAttachment(type: .image)
            case 1: NotificationManager.shared.addNotificationWithAttachment(type: .gif)
            case 2: NotificationManager.shared.addNotificationWithAttachment(type: .audio)
            case 3: NotificationManager.shared.addNotificationWithAttachment(type: .video)
            default: break
            }
            
        case 2: // Category notifications
            switch indexPath.row {
            case 0: NotificationManager.shared.addNotificationForCategory1()
            case 1: NotificationManager.shared.addNotificationForCategory2()
            case 2: NotificationManager.shared.addNotificationForCategory3()
            default: break
            }
            
        case 3: // Custom UI notifications
            switch indexPath.row {
            case 0: NotificationManager.shared.addNotificationForCustomMediaPlayer()
            default: break
            }
            
        default: break
        }
    }
}
