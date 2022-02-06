//
//  ViewController.swift
//  SampleApp
//
//  Copyright © 2021 Sage Bionetworks. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit
import Arc

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArcAssessmentDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellRows.allCases.count
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signatureImageView: UIImageView!

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
        let stateList = row?.stateList ?? [.context]
                
        // This is supplemental information about this specific session
        // within the context of the study schedule
        // This is optional, and will be simply copied into the ArcAssessmentResult
        let arcSupplementalInfo = ArcAssessmentSupplementalInfo(
            sessionID: 0, sessionAvailableDate: Date(), weekInStudy: 0, dayInWeek: 0, sessionInDay: 0)
        
        if let sampleAppNavController = Arc.shared.appNavigation as? SampleAppNavigationController,
           let vc = sampleAppNavController.startTest(stateList: stateList, info: arcSupplementalInfo) {
            Arc.shared.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func assessmentComplete(result: ArcAssessmentResult?) {
        self.dismiss(animated: true, completion: {
            let signatureResults = result?.signatures
            if let firstSignatureData = signatureResults?.first?.data {
                self.signatureImageView?.image = UIImage(data: firstSignatureData)
            } else {
                self.signatureImageView?.image = nil
            }
            if let jsonResult = result?.fullTestSession?.tests.first?.data as? CognitiveTest,
               let jsonData = jsonResult.encode(outputFormatting: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        })
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
    
    var stateList: [SampleAppState] {
        switch(self) {
        case .contextSurvey:
            return [.signatureStart, .context, .signatureEnd]
        case .wakeSurvey:
            return [.wake]
        case .chronotypeSurvey:
            return [.chronotype]
        case .symbolsTest:
            return [.symbolsTest]
        case .gridsTest:
            return [.gridTest]
        case .pricingTest:
            return [.priceTest]
        case .all:
            return SampleAppState.fullTest
        }
    }
}

class CustomTableViewCell: UITableViewCell {
    static var cellName = "CustomTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
}
