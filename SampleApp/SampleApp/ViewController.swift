//
//  ViewController.swift
//  SampleApp
//
//  Created by Michael L DePhillips on 2/1/22.
//

import UIKit
import Arc

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellRows.allCases.count
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = self.tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellName, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let row = CellRows(rawValue: indexPath.row)
        customCell.titleLabel.text = row?.title
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let row = CellRows(rawValue: indexPath.row)
        
        var vc: UIViewController? = nil
        switch(row) {
        case .contextSurvey:
            let controller:BasicSurveyViewController = .init(file: "context", surveyId: nil, showHelp: false)
            vc = controller
        case .chronotypeSurvey:
            let controller:ACWakeSurveyViewController = .init(file:"chronotype")
            vc = controller
        case .wakeSurvey:
            let controller:ACWakeSurveyViewController = .init(file:"wake")
            vc = controller
        default:
            // no-op
            let i = 0
        }        
                
        if let vcUnwrapped = vc {
            self.show(vcUnwrapped, sender: self)
        }
    }
}

enum CellRows: Int, CaseIterable {
    case contextSurvey = 0
    case wakeSurvey
    case chronotypeSurvey
    case symbolsTest
    case gridsTest
    case pricingTest
    case all
    
    var title: String {
        switch(self) {
        case .contextSurvey:
            return "Context Survey"
        case .wakeSurvey:
            return "Wake Survey"
        case .chronotypeSurvey:
            return "Chronotype Survey"
        case .symbolsTest:
            return "Symbols Test"
        case .gridsTest:
            return "Grids Test"
        case .pricingTest:
            return "Pricing Test"
        case .all:
            return "All Tests"
        }
    }
}

class CustomTableViewCell: UITableViewCell {
    static var cellName = "CustomTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
}
