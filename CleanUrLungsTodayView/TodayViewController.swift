//
//  TodayViewController.swift
//  CleanUrLungsTodayView
//
//  Created by Thomas Prezioso on 8/30/16.
//  Copyright © 2016 Thomas Prezioso. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var craveLabel: UILabel!
    @IBOutlet var smokedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCraveLabel()
    }
    
    func updateCraveLabel() {
        let defaults = UserDefaults.init(suiteName: "group.CleanUrLungsTodayView")
        let cravedLabelString = defaults!.string(forKey: "cravedExtension")
        let smokedLabelString = defaults!.string(forKey: "smokeExtension")
        self.craveLabel.text = cravedLabelString
        self.smokedLabel.text = smokedLabelString
    }

    @IBAction func openAppButton(_ sender: AnyObject) {
        extensionContext?.open(NSURL(string:"CleanUrLungs://")! as URL, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}
