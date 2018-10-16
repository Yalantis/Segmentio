//
//  ContentViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

private func yal_isPhone6() -> Bool {
    let size = UIScreen.main.bounds.size
    let minSide = min(size.height, size.width)
    let maxSide = max(size.height, size.width)
    return (abs(minSide - 375.0) < 0.01) && (abs(maxSide - 667.0) < 0.01)
}

class ExampleTableViewCell: UITableViewCell {
    @IBOutlet fileprivate weak var hintLabel: UILabel!
}

class ContentViewController: UIViewController {
    
    @IBOutlet fileprivate weak var cardNameLabel: UILabel!
    @IBOutlet fileprivate weak var hintTableView: UITableView!
    @IBOutlet fileprivate weak var bottomCardConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var heightConstraint: NSLayoutConstraint!
    
    var disaster: Disaster?
    fileprivate var hints: [String]?
    
    class func create() -> ContentViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! ContentViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hintTableView.rowHeight = UITableView.automaticDimension
        hintTableView.estimatedRowHeight = 100
        
        if yal_isPhone6() {
            bottomCardConstraint.priority = UILayoutPriority(rawValue: 900)
            heightConstraint.priority = UILayoutPriority(rawValue: 1000)
            heightConstraint.constant = 430
        } else {
            bottomCardConstraint.priority = UILayoutPriority(rawValue: 1000)
            heightConstraint.priority = UILayoutPriority(rawValue: 900)
        }
        
        if let disaster = disaster {
            cardNameLabel.text = disaster.cardName
            hints = disaster.hints
        }
    }
    
}

extension ContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hints?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExampleTableViewCell
        cell.hintLabel?.text = hints?[indexPath.row]
        return cell
    }
    
}
