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
        let defaults = NSUserDefaults.init(suiteName: "group.CleanUrLungsTodayView")
        let cravedLabelString = defaults!.stringForKey("cravedExtension")
        let smokedLabelString = defaults!.stringForKey("smokeExtension")
        self.craveLabel.text = cravedLabelString
        self.smokedLabel.text = smokedLabelString
    }
    
    //MARK: ADD BUTTON TO OPEN UP APP
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
}
