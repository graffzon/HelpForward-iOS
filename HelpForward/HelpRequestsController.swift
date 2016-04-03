//
//  HelpRequestsController.swift
//  HelpForward
//
//  Created by Kirill Zonov on 02.04.16.
//  Copyright © 2016 Kirill Zonov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HelpRequestsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var helpResponsesSendedByAnyone: UILabel!
    @IBOutlet weak var helpResponsesSendedByMe: UILabel!
    @IBOutlet weak var createdHelpRequestsCompletedByAnyone: UILabel!
    @IBOutlet weak var helpRequestsTable: UITableView!
    
    var items: [String] = ["We", "Heart", "Swift", "asd", "qwerty", "asdasdasd"]
    @IBOutlet weak var assistedHelpRequestCompletedByMe: UILabel!
    var helpRequests: JSON = []

    // stuff with locked - is stinky workaround, but sorry, it's 2 am.
    var lockers: Int = 0
    
    override func viewDidLoad() {
        let currentUserId = NSUserDefaults.standardUserDefaults().stringForKey("currentUserId")! as String
        loadRequests(currentUserId)
//        prepareUserInfoData(currentUserId)
        while(self.lockers != 0) {wait()}
        super.viewDidLoad()
        self.helpRequestsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func loadRequests(currentUserId: String) {
        self.lockers += 1
        Alamofire.request(.GET, "http://127.0.0.1:3000/api/help_requests.json", parameters: ["user_id": currentUserId])
            .responseJSON { response in
                self.helpRequests = JSON(response.result.value!)
                self.lockers = self.lockers - 1
        }
    }
    
//    func prepareUserInfoData(currentUserId: String) {
//        self.lockers += 1
//        Alamofire.request(.GET, "http://127.0.0.1:3000/api/help_requests.json", parameters: ["user_id": currentUserId])
//            .responseJSON { response in
//                self.helpRequests = JSON(response.result.value!)
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.helpRequests.count)
        return self.helpRequests.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.helpRequestsTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        if let helpRequestTitle = self.helpRequests.arrayObject![indexPath.row]["title"] as? String {
                cell.textLabel?.text = "\(helpRequestTitle)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    private func wait()
    {
        NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 1))
    }
}
