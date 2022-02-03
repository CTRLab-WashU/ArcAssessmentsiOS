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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        case .symbolsTest:
            let symbolsVc:SymbolsTestViewController = .get()
            let controller:InstructionNavigationController = .get()
            controller.nextVc = symbolsVc
            controller.titleOverride = "Test \(ACState.testTaken + 1) of 3".localized(ACTranslationKey.testing_header_1)
                .replacingOccurrences(of: "1", with: "\(ACState.testTaken + 1)")
                .replacingOccurrences(of: "{Value2}", with: "3")
            controller.load(instructions: "TestingIntro-Symbols")
            vc = controller
        case .pricingTest:
            let priceVc:PricesTestViewController = .get()
            let controller:InstructionNavigationController = .get()
            controller.nextVc = priceVc
            controller.titleOverride = "Test \(ACState.testTaken + 1) of 3".localized(ACTranslationKey.testing_header_1)
                .replacingOccurrences(of: "1", with: "\(ACState.testTaken + 1)")
                .replacingOccurrences(of: "{Value2}", with: "3")
            
            controller.load(instructions: "TestingIntro-Prices")
            vc = controller
        case .gridsTest:
            let gridsVc:ExtendedGridTestViewController = .get(nib:"ExtendedGridTestViewController")
            let controller:InstructionNavigationController = .get()
            controller.nextVc = gridsVc
            controller.titleOverride = "Test \(ACState.testTaken + 1) of 3".localized(ACTranslationKey.testing_header_1)
            .replacingOccurrences(of: "1", with: "\(ACState.testTaken + 1)")
            controller.load(instructions: "TestingIntro-Grids")
            vc = controller
        default:
            // no-op
            let i = 0
        }
                
        if let vcUnwrapped = vc {
            vcUnwrapped.modalPresentationStyle = .fullScreen
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
