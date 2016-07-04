//
//  ContentViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

private func yal_isPhone6() -> Bool {
    let size = UIScreen.mainScreen().bounds.size
    let minSide = min(size.height, size.width)
    let maxSide = max(size.height, size.width)
    return (fabs(minSide - 375.0) < 0.01) && (fabs(maxSide - 667.0) < 0.01)
}

class ExampleTableViewCell: UITableViewCell {
    @IBOutlet private weak var hintLabel: UILabel!
}

class ContentViewController: UIViewController {
    
    @IBOutlet private weak var cardNameLabel: UILabel!
    @IBOutlet private weak var hintTableView: UITableView!
    @IBOutlet private weak var bottomCardConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    var disaster: Disaster?
    private var hints: [String]?
    
    class func create() -> ContentViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewControllerWithIdentifier(String(self)) as! ContentViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hintTableView.rowHeight = UITableViewAutomaticDimension
        hintTableView.estimatedRowHeight = 100
        
        if yal_isPhone6() {
            bottomCardConstraint.priority = 900
            heightConstraint.priority = 1000
            heightConstraint.constant = 430
        } else {
            bottomCardConstraint.priority = 1000
            heightConstraint.priority = 900
        }
        
        if let disaster = disaster {
            cardNameLabel.text = disaster.cardName
            hints = disaster.hints
        }
    }
    
}

extension ContentViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hints?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ExampleTableViewCell
        cell.hintLabel?.text = hints?[indexPath.row]
        return cell
    }
    
}